//
//  RestaurantTagViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit
import Toast

// MARK: 명지맛집 > 태그CollectionView셀 클릭 후 나오는 페이지입니다.
class RestaurantTagViewController: BaseViewController {
    // MARK: - Views
    let backButton = UIButton().then{
        $0.setImage(UIImage(named: "arrow_left"), for: .normal)
    }
    let subTitleLabel = UILabel().then{
        $0.text = "# 모아뒀으니 골라보세요!"
        $0.font = UIFont.NotoSansKR(size: 24, family: .Bold)
        $0.textColor = .white
    }

    // MARK: - Life Cycles
    var tagResultTableView: UITableView!
    var tagKeyword: String!
    var tagResult: [KakaoResultModel] = []
    var campusInfo: CampusInfo = .seoul    // default값 - 인캠
    var pageNum: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        setCampusInfo()
        setUpTableView(dataSourceDelegate: self)
        setUpView()
        setUpConstraint()
        
        self.backButton.addTarget(self, action: #selector(goBackButtonDidTap), for: .touchUpInside)
    }
    override func viewDidAppear(_ animated: Bool) {
        if let tagKeyword = self.tagKeyword {self.subTitleLabel.text = "# 명지\(tagKeyword)"}
        
        // DATA
        self.tagResult.removeAll()
        guard let tagKeyword = self.tagKeyword else {return}
        KakaoMapDataManager().tagMapDataManager(tagKeyword, pageNum, self)
    }
    // MARK: Actions
    @objc func goBackButtonDidTap() {
        UIDevice.vibrate()
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Functions
    func setCampusInfo() {
        if let userCampus  = UserDefaults.standard.value(forKey: "userCampus") {
            switch userCampus as! String {
            case CampusInfo.seoul.name:
                campusInfo = .seoul
            case CampusInfo.yongin.name:
                campusInfo = .yongin
            default: return
            }
        }
    }
    func setUpTableView(dataSourceDelegate: UITableViewDelegate & UITableViewDataSource) {
        tagResultTableView = UITableView()
        tagResultTableView.then{
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
            
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
        }
    }
    func setUpView() {
        super.navigationView.addSubview(backButton)
        super.navigationView.addSubview(subTitleLabel)
        
        self.view.addSubview(tagResultTableView)
    }
    func setUpConstraint() {
        backButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-23)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing).offset(10)
            make.centerY.equalTo(backButton)
        }
        tagResultTableView.snp.makeConstraints { make in
            make.top.equalTo(super.navigationView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
// MARK: - TableView delegate
extension RestaurantTagViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if ((indexPath.row + 1) %  15 == 0) && ((indexPath.row + 1) /  15 == pageNum) && (pageNum < 3) {
            pageNum = pageNum + 1
            guard let tagKeyword = self.tagKeyword else {return}
            KakaoMapDataManager().tagMapDataManager(tagKeyword, pageNum, self)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.tagResult.count ?? 0
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.delegate = self
        let itemIdx = indexPath.item
        cell.setUpData(self.tagResult[itemIdx])
        cell.campusInfo = self.campusInfo
        cell.setupLayout(todo: .search)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
// MARK: - API Success
extension RestaurantTagViewController {
    func kakaoTagMapSuccessAPI(_ result: [KakaoResultModel]) {
        for tagData in result {
            self.tagResult.append(tagData)
        }
        if pageNum == 1 {reloadDataAnimation()}
        else {self.tagResultTableView.reloadData()}
    }
    func kakaoTagNoResultAPI() {
        self.tagResult.removeAll()
        self.pageNum = 1
        reloadDataAnimation()
    }
    func reloadDataAnimation() {
        // reload data with animation
        UIView.transition(with: self.tagResultTableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
                          self.tagResultTableView.reloadData()},
                          completion: nil);
    }
}

// MARK: - Delegate Extension
extension RestaurantTagViewController: RestaurantCellDelegate {
    func showToast(message: String) {
        self.view.makeToast(message, duration: 1.0, position: .center)
    }
}
