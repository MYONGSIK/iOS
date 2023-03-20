//
//  RestaurantViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit
import Toast

// MARK: 맛집 검색 페이지
class RestaurantSearchViewController: BaseViewController {
    // MARK: Views
    let backButton = UIButton().then{
        $0.setImage(UIImage(named: "arrow_left"), for: .normal)
    }
    lazy var searchButton = UIButton().then{
        $0.setImage(UIImage(named: "search"), for: .normal)
        $0.frame = CGRect(x: 0, y: 0, width: 24, height: 22)
    }
    var searchTextField = UITextField().then{
        $0.placeholder = "가고싶은 명지맛집을 검색 하세요."
        $0.font = UIFont.NotoSansKR(size: 15, family: .Regular)
        $0.clearButtonMode = .never
        $0.borderStyle = .none
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 19
        $0.addPadding(left: 16, right: 40)
        
        // 화면이 시작되자마자 키보드가 활성화됩니다.
        $0.becomeFirstResponder()
    }
    
    // MARK: Life Cycles
    var searchKeyword: String = ""
    var searchResultTableView: UITableView!
    var searchResult: [KakaoResultModel] = []
    
    var searchStoreResult: [StoreModel] = []
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
        
        backButton.addTarget(self, action: #selector(goBackButtonDidTap), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(searchTextFieldEditingChanged(_:)), for: .editingChanged)
        
        searchResultTableView.keyboardDismissMode = .onDrag
        searchTextField.delegate = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: Actions
    @objc func goBackButtonDidTap() {
        UIDevice.vibrate()
        self.navigationController?.popViewController(animated: true)
    }
    @objc func searchButtonDidTap() {
        UIDevice.vibrate()
        self.view.endEditing(true)
    }
    @objc func searchTextFieldEditingChanged(_ sender: UITextField) {
        // 입력값이 바뀔 때마다 기존결과값은 초기화, 현재 결과값을 출력합니다.
        pageNum = 1
        self.searchResult.removeAll()
        
        let text = sender.text ?? ""
        self.searchKeyword = text
        KakaoMapDataManager().searchMapDataManager(text, pageNum, self)
    }
    // MARK: Functions
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
        searchResultTableView = UITableView()
        searchResultTableView.then{
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
            $0.backgroundColor = .white

            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
        }
    }
    func setUpView() {
        super.navigationView.addSubview(searchTextField)
        super.navigationView.addSubview(backButton)
        searchTextField.addSubview(searchButton)
        
        self.view.addSubview(searchResultTableView)
    }

    func setUpConstraint() {
        backButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-23)
        }
        searchTextField.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-23)
            make.leading.equalTo(backButton.snp.trailing).offset(20)
            make.centerY.equalTo(backButton)
            make.height.equalTo(39)
        }
        searchButton.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(22)
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
        searchResultTableView.snp.makeConstraints { make in
            make.top.equalTo(super.navigationView.snp.bottom).offset(22)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
// MARK: - TableView delegate
extension RestaurantSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /*
         카카오API에서는 한 페이지에 최대 15개의 결과값이 나옵니다.
         최대 3페이지가 나옵니다.
         따라서 총 최대 45개의 결과값이 나온다고 할 수 있겠습니다.
         아래의 if조건문: 무한 스크롤
         */
        if ((indexPath.row + 1) %  15 == 0) && ((indexPath.row + 1) /  15 == pageNum) && (pageNum < 3) {
            pageNum = pageNum + 1
            KakaoMapDataManager().searchMapDataManager(self.searchKeyword, pageNum, self)
            print("pageNum:", pageNum)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.searchResult.count ?? 0
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.delegate = self
        let itemIdx = indexPath.item
        cell.setUpData(self.searchResult[itemIdx])
        cell.campusInfo = self.campusInfo
        cell.setupLayout(todo: .search)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
// MARK: - UITextField delegate
extension RestaurantSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
// MARK: - API Success
extension RestaurantSearchViewController {
    func kakaoSearchMapSuccessAPI(_ result: [KakaoResultModel]) {
        for searchData in result {
            self.searchResult.append(searchData)
        }
        if pageNum == 1 {reloadDataAnimation()}
        else {self.searchResultTableView.reloadData()}
    }
    func kakaoSearchNoResultAPI() {
        self.searchResult.removeAll()
        self.pageNum = 1
        reloadDataAnimation()
    }
    // 결과값이 나올 때, Tableview에 부드러운 애니메이션을 줍니다.
    func reloadDataAnimation() {
        // reload data with animation
        UIView.transition(with: self.searchResultTableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
                          self.searchResultTableView.reloadData()},
                          completion: nil);
    }
}

// MARK: - Delegate Extension
extension RestaurantSearchViewController: RestaurantCellDelegate {
    func showToast(message: String) {
        self.view.makeToast(message, duration: 1.0, position: .center)
    }
}
