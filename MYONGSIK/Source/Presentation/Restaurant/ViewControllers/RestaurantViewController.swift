//
//  RestaurantViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit

class RestaurantViewController: UIViewController {
    // MARK: Views
    let navigationView = UIView().then{
        $0.backgroundColor = .signatureBlue
        $0.clipsToBounds = true
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        setUpView()
        setUpConstraint()
        
        searchButton.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(searchTextFieldEditingChanged(_:)), for: .editingChanged)
    }
    // MARK: Actions
    @objc func searchButtonDidTap() {
        KakaoMapDataManager().searchMapDataManager(self.searchKeyword, self)
    }
    @objc func searchTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        self.searchKeyword = text
        KakaoMapDataManager().searchMapDataManager(text, self)
    }
    // MARK: Functions
    func setUpView() {
        self.view.addSubview(navigationView)
        navigationView.addSubview(searchTextField)
        searchTextField.addSubview(searchButton)
        
    }

    func setUpConstraint() {
        navigationView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            if UIDevice.current.hasNotch {make.height.equalTo(121)}
            else {make.height.equalTo(91)}
        }
        searchTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(23)
            make.bottom.equalToSuperview().offset(-19)
            make.height.equalTo(39)
        }
        searchButton.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(22)
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
    }
}
