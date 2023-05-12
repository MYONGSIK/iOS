//
//  HeartViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit
import RealmSwift

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
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        setUpTableView(dataSourceDelegate: self)
        getHeartData()
        setUpView()
        setUpConstraint()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getHeartData()
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
            if store.name == self.heartListData[indexPath.row].placeName {
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
//        let vc = WebViewController()
//        vc.webURL = link
//        vc.placeName = placeName
//        vc.category = category
//        self.navigationController!.pushViewController(vc, animated: true)
    }
}
// MARK: - Get Realm datas
extension HeartViewController {
    func getHeartData() {
        self.heartListData.removeAll()
        
        let hearts = realm.objects(HeartListData.self)
        for heart in hearts {
            self.heartListData.append(HeartListModel(placeName: heart.placeName, category: heart.category, placeUrl: heart.placeUrl))
        }
        
        heartListData.forEach { _ in
            isSelectedCell.append(false)
        }
        
        fetchHeartData()
    }
    func fetchHeartData() {
        let phoneId = RegisterUUID.shared.getDeviceID()
        APIManager.shared.getData(urlEndpointString: Constants.postHeart + "/" + phoneId,
                                  dataType: APIModel<Data>.self,
                                  parameter: nil,
                                  completionHandler: { response in
            print(response.data!.content)
            self.storeListData = response.data!.content
            self.reloadDataAnimation()
        })
    }
    func reloadDataAnimation() {
        // reload data with animation
        UIView.transition(with: self.heartTableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
                          self.heartTableView.reloadData()},
                          completion: nil);
    }
}

extension HeartViewController: HeartListDelegate {
    func deleteHeart(placeName: String) {

        let predicate = NSPredicate(format: "placeName = %@", placeName)
        let objc = realm.objects(HeartListData.self).filter(predicate)
        try! realm.write { realm.delete(objc) }

        
        heartListData = []
        getHeartData()
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
