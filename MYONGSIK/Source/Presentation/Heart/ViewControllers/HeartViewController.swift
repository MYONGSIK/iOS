//
//  HeartViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit
import Alamofire

// MARK: 찜꽁리스트 페이지
class HeartViewController: MainBaseViewController {
    
    // MARK: Life Cycles
    let emptyLabel = UILabel().then {
        $0.text = "찜꽁리스트가 비어있어요! \n맛집을 찜꽁해 나만의 맛집 리스트를 만들어봐요!"
        $0.numberOfLines = 0
        $0.textColor = .lightGray
        $0.font = UIFont.NotoSansKR(size: 14, family: .Bold)
        $0.textAlignment = .center
    }
    var heartTableView: UITableView!
    var heartListData: [HeartListModel] = []
    var storeListData: [StoreModel] = []
    var isSelectedCell: [Bool] = []
    private var campusInfo: CampusInfo = .yongin
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        setCampusInfo()
        setUpTableView(dataSourceDelegate: self)
        setUpView()
        setUpConstraint()
    }

    
    
    private func setCampusInfo() {
        if let userCampus  = UserDefaults.standard.value(forKey: "userCampus") {
            switch userCampus as! String {
            case CampusInfo.seoul.name:
                campusInfo = .seoul
            case CampusInfo.yongin.name:
                campusInfo = .yongin
            default:
                return
            }
        }
    }
    
    
    // MARK: Functions
    func setUpTableView(dataSourceDelegate: UITableViewDelegate & UITableViewDataSource) {
        heartTableView = UITableView()
        heartTableView.then{
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.register(HeartListTableViewCell.self, forCellReuseIdentifier: "HeartListTableViewCell")
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none

            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
//            $0.estimatedRowHeight = UITableView.automaticDimension
            
            
        }
    }
    func setUpView() {
        self.view.addSubview(emptyLabel)
        self.view.addSubview(heartTableView)
    }
    func setUpConstraint() {
        heartTableView.snp.makeConstraints { make in
            make.top.equalTo(super.navigationImgView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        if heartListData.count == 0 {
            heartTableView.isHidden = true
            emptyLabel.isHidden = false
            
            emptyLabel.snp.makeConstraints {
                $0.centerX.centerY.equalToSuperview()
            }
        } else {
            heartTableView.isHidden = false
            emptyLabel.isHidden = true
            
            heartTableView.snp.makeConstraints { make in
                make.top.equalTo(super.navigationImgView.snp.bottom).offset(20)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
        }
    }
    

}
// MARK: - TableView delegate
extension HeartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.heartListData.count
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeartListTableViewCell", for: indexPath) as? HeartListTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        storeListData.forEach { store in
            if store.name == self.heartListData[indexPath.row].placeName! {
                cell.setUpData(store, isSelect: isSelectedCell[indexPath.row])
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSelectedCell[indexPath.row] {
            return 150
        }else {
            return 90
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIDevice.vibrate()
        
        isSelectedCell[indexPath.row].toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
extension HeartViewController: HeartListDelegate {
    func deleteHeart(placeName: String) {
        // MARK: - 서버와 통신해 찜콩리스트 삭제
        
        heartListData = []
        setUpConstraint()
    }
    
    func reloadTableView() {
        self.heartTableView.reloadData()
    }
    
    func moveToWebVC(link: String) {
        let vc = WebViewController()
        vc.webURL = link
        vc.heartButton.isHidden = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
