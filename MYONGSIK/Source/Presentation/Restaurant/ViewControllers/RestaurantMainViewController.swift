//
//  RestaurantMainViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit
import SnapKit
import Then
import Toast
import Alamofire

// MARK: '명지 맛집' 페이지
class RestaurantMainViewController: MainBaseViewController {
    lazy var refreshControl = UIRefreshControl().then {
        $0.addTarget(self, action: #selector(refreshContentView), for: .valueChanged)
    }
    let searchButton = UIButton().then{
        $0.setImage(UIImage(named: "search_white"), for: .normal)
        $0.addTarget(self, action: #selector(goSearchButtonDidTap), for: .touchUpInside)
    }

    // MARK: Life Cycles
    var campusInfo: CampusInfo = .seoul    // default값 - 인캠
    
    var restaurantMainTableView: UITableView!
    var searchResult: [KakaoResultModel] = []
    
    var rankResults: [StoreModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        super.topLabel.text = "명지맛집"
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        setCampusInfo()
        setUpTableView(dataSourceDelegate: self)
        setUpView()
        setUpConstraint()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        //DATA
        DispatchQueue.main.async {
//            self.searchResult.removeAll()
            KakaoMapDataManager().randomMapDataManager(self)

//            self.rankResults.removeAll()
            self.fetchRankData()
            self.reloadDataAnimation()
        }
    }
    
    
    
    // MARK: Actions
    @objc func goSearchButtonDidTap(_ sender: UIButton) {
        UIDevice.vibrate()
        let vc = RestaurantSearchViewController()
        vc.searchStoreResult = self.rankResults
        vc.campusInfo = self.campusInfo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Functions
    func setCampusInfo() {
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
    
    func setUpTableView(dataSourceDelegate: UITableViewDelegate & UITableViewDataSource) {
        restaurantMainTableView = UITableView()
        restaurantMainTableView.then{
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
            $0.register(TagTableViewCell.self, forCellReuseIdentifier: "TagTableViewCell")
            $0.backgroundColor = .white
            
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
        }
    }
    func setUpView() {
        super.navigationImgView.addSubview(searchButton)
        self.view.addSubview(restaurantMainTableView)
        restaurantMainTableView.refreshControl = refreshControl
    }
    func setUpConstraint() {
        searchButton.snp.makeConstraints { make in
            make.width.height.equalTo(25)
            make.centerY.equalTo(topLogoImg)
            make.trailing.equalToSuperview().inset(22)
        }
        restaurantMainTableView.snp.makeConstraints { make in
            make.top.equalTo(super.navigationImgView.snp.bottom).inset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    func setSortButtonCell(_ cell: UITableViewCell) {
        let titleLabel = UILabel().then {
            $0.text = "#명지인이 선택한 맛집"
            $0.numberOfLines = 2
            $0.font = UIFont.NotoSansKR(size: 22, family: .Bold)
        }
        
//        let likeOrder = UIAction(title: "인기순", image: nil, handler: { _ in print("인기순 선택") })
//        let distanceOrder = UIAction(title: "거리순", image: nil, handler: { _ in print("거리순 선택") })
//
//        let sortButton = UIButton(type: .system).then {
//            $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
//            $0.semanticContentAttribute = .forceRightToLeft
//            $0.tintColor = .gray
//            $0.layer.cornerRadius = 15
//
//            $0.menu = UIMenu(
//                title: "",
//                image: nil,
//                identifier: nil,
//                options: .displayInline,
//                children: [likeOrder, distanceOrder]
//            )
//            $0.showsMenuAsPrimaryAction = true
//            $0.changesSelectionAsPrimaryAction = true
//        }
        cell.contentView.addSubview(titleLabel)
//        cell.contentView.addSubview(sortButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5)
            $0.leading.equalToSuperview().inset(15)
        }
        
//        sortButton.snp.makeConstraints {
//            $0.centerY.equalTo(titleLabel)
//            $0.trailing.equalToSuperview().inset(15)
//            $0.height.equalTo(30)
//            $0.width.equalTo(80)
//        }
    }
    @objc private func refreshContentView() {
        refreshControl.beginRefreshing()
        DispatchQueue.main.async {
//            self.rankResults.removeAll()
            self.fetchRankData()
            self.reloadDataAnimation()
        }
        refreshControl.endRefreshing()
    }
}
// MARK: - TableView delegate
/*
 '#모아뒀으니 골라보세요!' 셀 하나,
 태그 CollectionView 셀 하나,
 '#명식이가 준비했습니다!' 셀 하나,
 그 아래에는 추천 맛집 결과값이 나오기 때문에 총 Tableview의 셀 개수는 count+3 입니다.
 시간이 급해 이렇게 짰고, 자유롭게 수정하시면 되겠습니다.
 */
extension RestaurantMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.rankResults.count ?? 0
        return count + 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = indexPath.row
        switch tag {
        case 0:
            let cell = UITableViewCell()
            DispatchQueue.main.async {
                cell.textLabel?.text = "#모아뒀으니 골라보세요!"
                cell.textLabel?.font = UIFont.NotoSansKR(size: 22, family: .Bold)
                cell.selectionStyle = .none
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TagTableViewCell", for: indexPath) as? TagTableViewCell else { return UITableViewCell() }
            DispatchQueue.main.async {
                cell.setCollectionView(self)
                cell.selectionStyle = .none
            }
            return cell
        case 2:
            let cell = UITableViewCell()
            DispatchQueue.main.async {
                cell.selectionStyle = .none
                self.setSortButtonCell(cell)
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }

            DispatchQueue.main.async {
                let itemIdx = indexPath.item - 3
                cell.campusInfo = self.campusInfo
                cell.setUpDataWithRank(self.rankResults[itemIdx])
                cell.delegate = self
                cell.selectionStyle = .none
                cell.setupLayout(todo: .main)
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tag = indexPath.row
        switch tag {
        case 0:
            return 60
        case 1:
            return 84
        case 2:
            return 46
        default:
            return 200
        }
    }
}
// MARK: - CollectionView delegate
extension RestaurantMainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier,
                                                            for: indexPath)
                as? TagCollectionViewCell else{ fatalError() }
        let tag = indexPath.row
        switch tag {
        case 0:
            cell.titleLabel.text = "#명지맛집"
        case 1:
            cell.titleLabel.text = "#명지카페"
        case 2:
            cell.titleLabel.text = "#명지술집"
        default:
            cell.titleLabel.text = "#명지빵집"
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIDevice.vibrate()
        
        var tagKeyword = ""
        let tag = indexPath.row
        switch tag {
        case 0:
            tagKeyword = "맛집"
        case 1:
            tagKeyword = "카페"
        case 2:
            tagKeyword = "술집"
        default:
            tagKeyword = "빵집"
        }
        let vc = RestaurantTagViewController()
        vc.tagKeyword = tagKeyword
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - API Success
extension RestaurantMainViewController {
    func kakaoRandomMapSuccessAPI(_ result: [KakaoResultModel]) {
        let resultCount = result.count ?? 0
        if resultCount >= 10 {self.searchResult = Array(result[0..<10])}
        else {self.searchResult = result}
        
        reloadDataAnimation()
    }
    func kakaoRandomNoResultAPI() {
        self.searchResult.removeAll()
        reloadDataAnimation()
    }
    func reloadDataAnimation() {
        // reload data with animation
        UIView.transition(with: self.restaurantMainTableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
                          self.restaurantMainTableView.reloadData()},
                          completion: nil);
    }
}


// MARK: - Delegate Extension
extension RestaurantMainViewController: RestaurantCellDelegate {
    func showToast(message: String) {
        self.view.makeToast(message, duration: 1.0, position: .center)
    }
}

// MARK: - API extension
extension RestaurantMainViewController {
    func fetchRankData() {
        let queryParam: Parameters = [
            "sort": "scrapCount,desc",
            "campus" : (campusInfo == .seoul) ? "SEOUL" : "YONGIN",
        ]
        APIManager.shared.getData(urlEndpointString: Constants.getStoreRank,
                                  dataType: StoreRankModel.self,
                                  parameter: queryParam,
                                  completionHandler: { [weak self] response in
//            print(response.data)
            if response.success {
                self?.rankResults = response.data.content
            } else {
                self?.showAlert(message: "맛집 순위 정보를 가져올 수 없습니다.")
            }

        })
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
