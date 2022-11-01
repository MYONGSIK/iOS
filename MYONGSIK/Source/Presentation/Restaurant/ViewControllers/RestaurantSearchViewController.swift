//
//  RestaurantViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit

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
    }
    
    // MARK: Life Cycles
    var searchKeyword: String = ""
    var searchResultTableView: UITableView!
    var searchResult: [KakaoResultModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        setUpTableView(dataSourceDelegate: self)
        setUpView()
        setUpConstraint()
        
        backButton.addTarget(self, action: #selector(goBackButtonDidTap), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(searchTextFieldEditingChanged(_:)), for: .editingChanged)
    }
    // MARK: Actions
    @objc func goBackButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func searchButtonDidTap() {
        KakaoMapDataManager().searchMapDataManager(self.searchKeyword, self)
    }
    @objc func searchTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        self.searchKeyword = text
        KakaoMapDataManager().searchMapDataManager(text, self)
    }
    // MARK: Functions
    func setUpTableView(dataSourceDelegate: UITableViewDelegate & UITableViewDataSource) {
        searchResultTableView = UITableView()
        searchResultTableView.then{
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
            
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.separatorStyle = .none
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
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom).offset(22)
        }
    }
}
// MARK: - TableView delegate
extension RestaurantSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.searchResult.count ?? 0
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        let itemIdx = indexPath.item
        cell.setUpData(self.searchResult[itemIdx])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemIdx = indexPath.item
        guard let link = self.searchResult[itemIdx].place_url else {return}
        ScreenManager().linkTo(viewcontroller: self, link)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: - API Success
extension RestaurantSearchViewController {
    func kakaoSearchMapSuccessAPI(_ result: [KakaoResultModel]) {
        self.searchResult = result
        self.searchResultTableView.reloadData()
    }
    func kakaoSearchNoResultAPI() {
        self.searchResult = []
        self.searchResultTableView.reloadData()
    }
}
