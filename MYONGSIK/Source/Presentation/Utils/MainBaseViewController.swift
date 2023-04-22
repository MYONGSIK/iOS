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
    let topLogoImg = UIImageView().then {
        $0.image = UIImage(named: "mainTopLogo")
        $0.clipsToBounds = true
    }
    
    // (자연캠인 경우) 위젯용 식당을 선택하기 위한 화면으로 넘어가는 설정 버튼
    let setCampusButton = UIButton().then{
        $0.setImage(UIImage(systemName: "gearshape"), for: .normal)
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(goSettingRestaurant(_:)), for: .touchUpInside)
        $0.isHidden = true
    }

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.view.addSubview(navigationImgView)
        navigationImgView.addSubview(topLogoImg)
        navigationImgView.addSubview(setCampusButton)

        navigationImgView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
//        topLabel.snp.makeConstraints {
//            $0.centerX.centerY.equalToSuperview()
//        }
        topLogoImg.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        setCampusButton.snp.makeConstraints {
            $0.width.height.equalTo(25)
            $0.centerY.equalTo(topLogoImg)
            $0.trailing.equalToSuperview().inset(22)
        }
    }
    
    @objc func goSettingRestaurant(_ sender: UIButton) {
        UIDevice.vibrate()
        let settingVC = SettingRestautrantViewController()
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
}
