//
//  RestaurantMainViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit

class RestaurantMainViewController: BaseViewController {
    let searchButton = UIButton().then{
        $0.setImage(UIImage(named: "search_white"), for: .normal)
    }
    let titleLabel = UILabel().then{
        $0.text = "명지맛집"
        $0.font = UIFont.NotoSansKR(size: 24, family: .Bold)
        $0.textColor = .white
    }

    // MARK: Life Cycles
    var restaurantMainTableView: UITableView!
    var searchResult: [KakaoResultModel] = []
    private let foodList = ["부대찌개", "국밥", "마라탕", "중식", "한식", "카페", "족발", "술집", "파스타", "커피", "삼겹살", "치킨", "떡볶이", "햄버거", "피자", "초밥", "회", "곱창", "냉면", "닭발"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        setUpTableView(dataSourceDelegate: self)
        setUpView()
        setUpConstraint()
        
        self.searchButton.addTarget(self, action: #selector(goSearchButtonDidTap), for: .touchUpInside)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        //DATA
        self.searchResult.removeAll()
        for i in 1...10 {
            let randomKeyword = foodList.randomElement() ?? ""
            KakaoMapDataManager().randomMapDataManager(randomKeyword, self)
        }
        reloadDataAnimation()
    }
    
    // MARK: Actions
    @objc func goSearchButtonDidTap() {
        let vc = RestaurantSearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Functions
    func setUpTableView(dataSourceDelegate: UITableViewDelegate & UITableViewDataSource) {
        restaurantMainTableView = UITableView()
        restaurantMainTableView.then{
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
            $0.register(TagTableViewCell.self, forCellReuseIdentifier: "TagTableViewCell")
            
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
        }
    }
    func setUpView() {
        super.navigationView.addSubview(titleLabel)
        super.navigationView.addSubview(searchButton)
        
        self.view.addSubview(restaurantMainTableView)
    }
    func setUpConstraint() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-22)
        }
        searchButton.snp.makeConstraints { make in
            make.width.height.equalTo(25)
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-22)
        }
        restaurantMainTableView.snp.makeConstraints { make in
            make.top.equalTo(super.navigationView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
// MARK: - TableView delegate
extension RestaurantMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.searchResult.count ?? 0
        return count + 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = indexPath.row
        switch tag {
        case 0:
            let cell = UITableViewCell()
            cell.textLabel?.text = "#모아뒀으니 골라보세요!"
            cell.textLabel?.font = UIFont.NotoSansKR(size: 22, family: .Bold)
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TagTableViewCell", for: indexPath) as? TagTableViewCell else { return UITableViewCell() }
            cell.setCollectionView(self)
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = UITableViewCell()
            cell.textLabel?.text = "#명지대에서\n가장 가기 좋은 곳은..."
            cell.textLabel?.numberOfLines = 2
            cell.textLabel?.font = UIFont.NotoSansKR(size: 22, family: .Bold)
            cell.selectionStyle = .none
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
            let itemIdx = indexPath.item - 3
            cell.setUpData(self.searchResult[itemIdx])
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tag = indexPath.row
        switch tag {
        case 0:
            return 60
        case 1:
            return 54
        case 2:
            return 90
        default:
            return 170
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemIdx = indexPath.item
        if itemIdx > 2 {
            guard let link = self.searchResult[itemIdx - 3].place_url else {return}
            guard let placeName = self.searchResult[itemIdx - 3].place_name else {return}
            guard let category = self.searchResult[itemIdx - 3].category_group_name else {return}
            
            let vc = WebViewController()
            vc.webURL = link
            vc.placeName = placeName
            vc.category = category
            self.navigationController!.pushViewController(vc, animated: true)
//            ScreenManager().linkTo(viewcontroller: self, link)
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
            cell.titleLabel.text = "#명지맛집"
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
            tagKeyword = "맛집"
        }
        let vc = RestaurantTagViewController()
        vc.tagKeyword = tagKeyword
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - API Success
extension RestaurantMainViewController {
    func kakaoSearchMapSuccessAPI(_ result: [KakaoResultModel]) {
        self.searchResult.append(result[0])
        reloadDataAnimation()
    }
    func kakaoSearchNoResultAPI() {
//        self.searchResult.removeAll()
//        reloadDataAnimation()
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
