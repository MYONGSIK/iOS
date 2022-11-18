//
//  MainBaseViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import Foundation
import UIKit

// 로고이미지가 중앙에 있는 메인페이지의 뷰컨입니다.
class MainBaseViewController: UIViewController {
    // MARK: Views
    // 상단바
    let navigationView = UIView().then{
        $0.backgroundColor = .signatureBlue
        $0.clipsToBounds = true
    }
    // 상단 로고 이미지
    let logoImage = UIImageView().then{
        $0.image = UIImage(named: "logo")
    }
    // 상단 제목
    let titleLabel = UILabel().then{
        $0.font = UIFont.NotoSansKR(size: 18, family: .Bold)
    }
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                
        //setUpView
        self.view.addSubview(navigationView)
        navigationView.addSubview(logoImage)
        self.view.addSubview(titleLabel)
        
        //setUpConstraint
        navigationView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            if UIDevice.current.hasNotch {make.height.equalTo(121)}
            else{make.height.equalTo(91)}
        }
        logoImage.snp.makeConstraints { make in
            make.width.equalTo(103)
            make.height.equalTo(78)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(38)
            make.centerX.equalToSuperview()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    // MARK: - Actions
    
}
