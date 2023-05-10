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
import DropDown

enum CellMode {
    case kakaoCell
    case rankCell
}

// MARK: '명지 맛집' 페이지
class RestaurantMainViewController: MainBaseViewController {
    lazy var refreshControl = UIRefreshControl().then {
        $0.addTarget(self, action: #selector(refreshContentView), for: .valueChanged)
    }
    let searchButton = UIButton().then{
        $0.setImage(UIImage(named: "search_white"), for: .normal)
        $0.addTarget(self, action: #selector(goSearchButtonDidTap), for: .touchUpInside)
    }
    
    let sortButton = UIButton(type: .system).then {
        $0.setTitle("인기순 ", for: .normal)
        $0.setImage(UIImage(named: "arrow_bottom"), for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.tintColor = .gray
        $0.layer.cornerRadius = 15
    }
    
    let sortDropDown = DropDown()

    // MARK: Life Cycles
    var cellMode: CellMode = .rankCell
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
        fetchRankData()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        //DATA
        DispatchQueue.main.async {
//            self.searchResult.removeAll()
            KakaoMapDataManager().randomMapDataManager(self)
//            self.getRandomRestaurants()

//            self.rankResults.removeAll()
            
//            self.fetchRankData()
//            self.reloadDataAnimation()
            self.checkSortMode()
        }
    }
    
    func checkSortMode() {
        if let sortValue = UserDefaults.standard.object(forKey: "restaurant_sort_value") {
            self.fetchRankData()
            switch sortValue as! String {
            case "scrapCount,desc":
                cellMode = .rankCell
            case "distance,asc":
                cellMode = .rankCell
            case "kakaoRandom":
                cellMode = .kakaoCell
                self.getRandomRestaurants()
            default: return
            }
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
    
    @objc func didTapSortButton() {
        sortDropDown.show()
    }
    func setSortButtonCell(_ cell: UITableViewCell) {
        sortDropDown.dataSource = ["인기순", "거리순", "추천순"]
        sortDropDown.selectedTextColor = .signatureBlue
        sortDropDown.anchorView = sortButton
        sortDropDown.bottomOffset = CGPoint(x: 0, y:(sortDropDown.anchorView?.plainView.bounds.height)!)
        sortDropDown.width = 80
        sortDropDown.cellHeight = 40
        sortButton.addTarget(self, action: #selector(didTapSortButton), for: .touchUpInside)
        sortDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.sortButton.setTitle(item, for: .normal)
            switch item {
            case "인기순":
                self?.sortButton.setTitle("인기순 ", for: .normal)
                self?.fetchDataWithSort(sort: "scrapCount,desc")
                UserDefaults.standard.set("scrapCount,desc", forKey: "restaurant_sort_value")
            case "거리순":
                self?.sortButton.setTitle("거리순 ", for: .normal)
                self?.fetchDataWithSort(sort: "distance,asc")
                UserDefaults.standard.set("distance,asc", forKey: "restaurant_sort_value")
            case "추천순":
                self?.sortButton.setTitle("추천순 ", for: .normal)
                self?.getRandomRestaurants()
                UserDefaults.standard.set("kakaoRandom", forKey: "restaurant_sort_value")
            default: return
            }
        }
        
        let titleLabel = UILabel().then {
            $0.text = "#명지인이 선택한 맛집"
            $0.numberOfLines = 2
            $0.font = UIFont.NotoSansKR(size: 22, family: .Bold)
        }
        
        cell.contentView.addSubview(titleLabel)
        cell.contentView.addSubview(sortButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5)
            $0.leading.equalToSuperview().inset(15)
        }
        
        sortButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(30)
            $0.width.equalTo(80)
        }
    }
    @objc private func refreshContentView() {
        refreshControl.beginRefreshing()
        DispatchQueue.main.async {
//            self.rankResults.removeAll()
            switch self.cellMode {
            case .rankCell: self.fetchRankData()
            case .kakaoCell: self.getRandomRestaurants()
            }
            
            self.reloadDataAnimation()
        }
        refreshControl.endRefreshing()
    }
    
    private func getRandomRestaurants() {
        KakaoMapDataManager().randomMapDataManager(self)
        self.kakaoRandomMapSuccessAPI(self.searchResult)
        self.cellMode = .kakaoCell
        self.reloadDataAnimation()
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
        switch self.cellMode {
        case .rankCell:
            let count = self.rankResults.count ?? 0
            return count + 3
        case .kakaoCell:
            let count = self.searchResult.count ?? 0
            return count + 3
        }
//        let count = self.rankResults.count ?? 0
//        return count + 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = indexPath.row
        switch tag {
        case 0:
            let cell = UITableViewCell()
            DispatchQueue.main.async {
                cell.textLabel?.text = "#명지맛집 모음!"
                cell.textLabel?.font = UIFont.NotoSansKR(size: 22, family: .Bold)
                cell.selectionStyle = .none
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TagTableViewCell", for: indexPath) as? TagTableViewCell else { return UITableViewCell() }
            DispatchQueue.main.async {
                cell.setTagView()
                cell.delegate = self
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
                
                switch self.cellMode {
                case .rankCell:
                    cell.setUpDataWithRank(self.rankResults[itemIdx])
                    cell.delegate = self
                    cell.selectionStyle = .none
                    cell.setupLayout(todo: .main)
                case .kakaoCell:
                    cell.setUpData(self.searchResult[itemIdx])
                    cell.delegate = self
                    cell.selectionStyle = .none
                    cell.setupLayout(todo: .random)
                }
                
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
            return 200
        case 2:
            return 46
        default:
//            switch self.cellMode {
//            case .rankCell: return 200
//            case .kakaoCell: return 170
//            }
            return 200
        }
    }
}

extension RestaurantMainViewController: TagCellDelegate {
    func didTapTagButton(tagKeyword: String) {
        let vc = RestaurantTagViewController()
        vc.tagKeyword = tagKeyword
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - API Success
extension RestaurantMainViewController {
    func kakaoRandomMapSuccessAPI(_ result: [KakaoResultModel]) {
        print("result count -> \(result.count)")
        let resultCount = result.count ?? 0
        if resultCount >= 20 {self.searchResult = Array(result[0..<20])}
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
        var queryParam: Parameters
        if let sortValue = UserDefaults.standard.object(forKey: "restaurant_sort_value") {

            switch sortValue as! String {
            case "scrapCount,desc":
                sortButton.setTitle("인기순 ", for: .normal)
            case "distance,asc":
                sortButton.setTitle("거리순 ", for: .normal)
            case "kakaoRandom":
                sortButton.setTitle("추천순 ", for: .normal)
            default: return
            }
            
            queryParam = [
                "sort": sortValue as! String,  
                "campus" : (campusInfo == .seoul) ? "SEOUL" : "YONGIN",
            ]
        } else {
            queryParam = [
                "sort": "scrapCount,desc",  // defalut : 인기순
                "campus" : (campusInfo == .seoul) ? "SEOUL" : "YONGIN",
            ]
        }
        
        APIManager.shared.getData(urlEndpointString: Constants.getStoreRank,
                                  dataType: StoreRankModel.self,
                                  parameter: queryParam,
                                  completionHandler: { [weak self] response in
            if response.success {
                self?.rankResults = response.data.content
                self?.reloadDataAnimation()
            } else {
                self?.showAlert(message: "맛집 순위 정보를 가져올 수 없습니다.")
            }

        })
    }
    
    func fetchDataWithSort(sort: String) {
        self.cellMode = .rankCell
        let queryParam: Parameters = [
            "sort": sort,
            "campus" : (campusInfo == .seoul) ? "SEOUL" : "YONGIN",
        ]
        APIManager.shared.getData(urlEndpointString: Constants.getStoreRank,
                                  dataType: StoreRankModel.self,
                                  parameter: queryParam,
                                  completionHandler: { [weak self] response in
            if response.success {
                self?.rankResults = response.data.content
                self?.reloadDataAnimation()
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
