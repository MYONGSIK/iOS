//
//  BaseViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/19.
//
import UIKit

// 기본 파란색 상단바 페이지입니다.
class BaseViewController: UIViewController {
    // MARK: - Properties
    // MARK: Views
    // 상단바
    let navigationView = UIView().then{
        $0.backgroundColor = .white
        $0.clipsToBounds = true
    }
    let borderView = UIView().then {
        $0.backgroundColor = .signatureBlue
    }
    // 상단 제목
    let titleLabel = UILabel().then{
        $0.font = UIFont.NotoSansKR(size: 24, family: .Bold)
        $0.textColor = .black
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        //setUpView
        self.view.addSubview(navigationView)
        self.view.addSubview(borderView)
        navigationView.addSubview(titleLabel)
        
        //setUpConstraint
        navigationView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            if UIDevice.current.hasNotch {make.height.equalTo(121)}
            else {make.height.equalTo(91)}
        }
        borderView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(navigationView.snp.bottom)
            $0.height.equalTo(1.5)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-22)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
}
