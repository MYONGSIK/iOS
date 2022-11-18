//
//  RestaurantMainViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit

// MARK: '명지 맛집' 페이지
class RestaurantMainViewController: BaseViewController {
    let searchButton = UIButton().then{
        $0.setImage(UIImage(named: "search_white"), for: .normal)
    }

    // MARK: Life Cycles
    var restaurantMainTableView: UITableView!
    var searchResult: [KakaoResultModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.titleLabel.text = "명지맛집"
        
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
        DispatchQueue.main.async {
            self.searchResult.removeAll()
            KakaoMapDataManager().randomMapDataManager(self)
        }
    }
    
    // MARK: Actions
    @objc func goSearchButtonDidTap() {
        UIDevice.vibrate()
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
        super.navigationView.addSubview(searchButton)
        
        self.view.addSubview(restaurantMainTableView)
    }
    func setUpConstraint() {
        searchButton.snp.makeConstraints { make in
            make.width.height.equalTo(25)
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-22)
        }
        restaurantMainTableView.snp.makeConstraints { make in
            make.top.equalTo(super.navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
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
        let count = self.searchResult.count ?? 0
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
                cell.textLabel?.text = "#명식이가 준비했습니다!"
                cell.textLabel?.numberOfLines = 2
                cell.textLabel?.font = UIFont.NotoSansKR(size: 22, family: .Bold)
                cell.selectionStyle = .none
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
            DispatchQueue.main.async {
                let itemIdx = indexPath.item - 3
                cell.setUpData(self.searchResult[itemIdx])
                cell.selectionStyle = .none
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
            return 170
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIDevice.vibrate()
        
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
