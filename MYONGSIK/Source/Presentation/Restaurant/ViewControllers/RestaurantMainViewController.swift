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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        setUpView()
        setUpConstraint()
        
        self.searchButton.addTarget(self, action: #selector(goSearchButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: Actions
    @objc func goSearchButtonDidTap() {
        let vc = RestaurantSearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Functions
    func setUpView() {
        super.navigationView.addSubview(titleLabel)
        super.navigationView.addSubview(searchButton)
    }
    func setUpConstraint() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-28)
        }
        searchButton.snp.makeConstraints { make in
            make.width.height.equalTo(25)
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-22)
        }
    }
}
