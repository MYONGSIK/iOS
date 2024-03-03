//
//  RestaurantViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit
import Toast
import Combine
import CombineCocoa

// MARK: 맛집 검색 페이지
class RestaurantSearchViewController: BaseViewController {
    var searchKeyword: String = ""
    var searchResult: [RestaurantModel] = []
    
    private let viewModel = RestaurantSearchViewModel()
    private var cancellabels = Set<AnyCancellable>()
    private var input: PassthroughSubject<RestaurantSearchViewModel.Input, Never> = .init()
    

    // MARK: Views
    var searchResultTableView: UITableView!
    
    let backButton = UIButton().then{
        $0.setImage(UIImage(named: "arrow_left_gray"), for: .normal)
        $0.addTarget(self, action: #selector(goBackButtonDidTap), for: .touchUpInside)
    }
    lazy var searchButton = UIButton().then{
        $0.setImage(UIImage(named: "search_blue"), for: .normal)
        $0.frame = CGRect(x: 0, y: 0, width: 24, height: 22)
        $0.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
    }
    var searchTextField = UITextField().then{
        $0.placeholder = "검색어를 입력하세요."
        $0.font = UIFont.NotoSansKR(size: 15, family: .Regular)
        $0.clearButtonMode = .never
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 19
        $0.layer.borderWidth = 2.0
        $0.layer.borderColor = UIColor.signatureBlue.cgColor
        $0.addPadding(left: 16, right: 40)
        
        // 화면이 시작되자마자 키보드가 활성화됩니다.
        $0.becomeFirstResponder()
    }
    
    // MARK: Life Cycles

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        setUpTableView(dataSourceDelegate: self)
        setup()
        setUpConstraint()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.cancellabels.removeAll()
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
    func setup() {
        searchResultTableView.keyboardDismissMode = .onDrag
        searchTextField.delegate = self
        
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
    
    func bind() {
        searchTextField.textPublisher.sink { [weak self] text in
            self?.input.send(.search(text ?? ""))
        }.store(in: &cancellabels)
        
        let output = viewModel.trastfrom(input.eraseToAnyPublisher())
        
        
        
        output.receive(on: DispatchQueue.main).sink {[weak self] event in
            switch event {
            case .updateSearchRes(let result):
                self?.searchResult = result
                self?.reloadDataAnimation()
            case .moveToWeb(let heart, let isHeart, let id):
                let vc = WebViewController()
                vc.heart = heart
                vc.isHeart = isHeart
                vc.id = id
                self?.navigationController?.pushViewController(vc, animated: true)
                break
            case .moveToMap(let urlStr, let isUrl):
                if isUrl {
                    let encodedStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    
                    if let url = URL(string: encodedStr), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    else { self?.view.makeToast("네이버 지도앱이 설치되어있지 않습니다!")}
                }else {
                    self?.view.makeToast("주소가 등록되어있지 않습니다!")
                }
                break
            case .moveToCall(let url, let isUrl):
                if isUrl {
                    if let openApp = URL(string: url), UIApplication.shared.canOpenURL(openApp) {
                        if #available(iOS 10.0, *) { UIApplication.shared.open(openApp, options: [:], completionHandler: nil) }
                        else { UIApplication.shared.openURL(openApp) }
                    }
                    else { self?.view.makeToast("번호가 등록되어있지 않습니다!")}
                }else {
                    self?.view.makeToast("번호가 등록되어있지 않습니다!")
                }
                break            }
        }.store(in: &cancellabels)
    }
    
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
// MARK: - TableView delegate
extension RestaurantSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.searchResult.count
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        let itemIdx = indexPath.item
        cell.searchInput = self.input
        cell.setupRestaurant(self.searchResult[itemIdx], .kakaoCell)
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

