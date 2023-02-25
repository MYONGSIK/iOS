//
//  MainBaseViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import Foundation
import UIKit
import SnapKit

// 로고이미지가 중앙에 있는 메인페이지의 뷰컨입니다.
class MainBaseViewController: UIViewController {
    // MARK: Views
    let navigationImgView = UIImageView().then{
        $0.image = UIImage(named: "mainTopBackImg")
        $0.clipsToBounds = true
        $0.backgroundColor = .white
        $0.isUserInteractionEnabled = true
    }
    
    let topLabel = UILabel().then {
        $0.text = "명식이"
        $0.font = UIFont.NotoSansKR(size: 18, family: .Bold)
        $0.textColor = .white
    }
    
    let setCampusButton = UIButton().then{
        $0.setImage(UIImage(systemName: "person.circle"), for: .normal)
//        $0.tintColor = .white
        $0.addTarget(self, action: #selector(goSplashView(_:)), for: .touchUpInside)
    }

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.view.addSubview(navigationImgView)
        navigationImgView.addSubview(topLabel)
        navigationImgView.addSubview(setCampusButton)

        navigationImgView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        topLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        setCampusButton.snp.makeConstraints {
            $0.width.height.equalTo(25)
            $0.centerY.equalTo(topLabel)
            $0.leading.equalToSuperview().inset(22)
        }
    }
    
    @objc func goSplashView(_ sender: UIButton) {
        UIDevice.vibrate()
        let splash = SplashViewController()
        splash.modalPresentationStyle = .fullScreen
        splash.modalTransitionStyle = .crossDissolve
        present(splash, animated: true)
    }
}
