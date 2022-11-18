//
//  HeartViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit
import RealmSwift

// MARK: 찜꽁리스트 페이지
class HeartViewController: BaseViewController {
    
    // MARK: Life Cycles
    var heartTableView: UITableView!
    var heartListData: [HeartListModel] = []
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.titleLabel.text = "나만의 찜꽁리스트"
        self.view.backgroundColor = .white
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        setUpTableView(dataSourceDelegate: self)
        setUpView()
        setUpConstraint()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        // DATA
        self.heartListData.removeAll()
        getHeartData()
    }
    // MARK: Functions
    func setUpTableView(dataSourceDelegate: UITableViewDelegate & UITableViewDataSource) {
        heartTableView = UITableView()
        heartTableView.then{
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.register(HeartListTableViewCell.self, forCellReuseIdentifier: "HeartListTableViewCell")
            
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
        }
    }
    func setUpView() {
        self.view.addSubview(heartTableView)
    }
    func setUpConstraint() {
        heartTableView.snp.makeConstraints { make in
            make.top.equalTo(super.navigationView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
// MARK: - TableView delegate
extension HeartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.heartListData.count ?? 0
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeartListTableViewCell", for: indexPath) as? HeartListTableViewCell else { return UITableViewCell() }
        let itemIdx = indexPath.item
        cell.setUpData(self.heartListData[itemIdx])
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIDevice.vibrate()
        
        let itemIdx = indexPath.item
        
        guard let link = self.heartListData[itemIdx].placeUrl else {return}
        guard let placeName = self.heartListData[itemIdx].placeName else {return}
        guard let category = self.heartListData[itemIdx].category else {return}
        
        let vc = WebViewController()
        vc.webURL = link
        vc.placeName = placeName
        vc.category = category
        self.navigationController!.pushViewController(vc, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: - Get Realm datas
extension HeartViewController {
    func getHeartData() {
        // 모든 객체 얻기
        let hearts = realm.objects(HeartListData.self)
        for heart in hearts {
            self.heartListData.append(HeartListModel(placeName: heart.placeName, category: heart.category, placeUrl: heart.placeUrl))
        }
        reloadDataAnimation()
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
