//
//  SplashViewController.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/02/20.
//

import UIKit
import SnapKit

enum Campus: String {
case seoul = "인문캠퍼스"
case yongin = "자연캠퍼스"
}

enum SeoulRestaurant: String {
case mcc = "MCC식당"
}


enum YonginRestaurant: String {
case staff = "교직원식당"
case dormitory = "생활관식당"
//case academy = "학관식당"
}

class SplashViewController: UIViewController {
    
    let titleImgView = UIImageView().then {
        $0.image = UIImage(named: "splashTitle")
        $0.clipsToBounds = true
    }
    
    let campusButtonStackView = UIStackView()
    
    let seoulCampusButton = UIButton().then {
        $0.setTitle(Campus.seoul.rawValue, for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(size: 16, family: .Bold)
        $0.layer.backgroundColor = UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1).cgColor
        $0.layer.cornerRadius = 25
    }
    
    let yonginCampusButton = UIButton().then {
        $0.setTitle(Campus.yongin.rawValue, for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(size: 16, family: .Bold)
        $0.layer.backgroundColor = UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1).cgColor
        $0.layer.cornerRadius = 25
    }
    
    let campusSetInfoButton = UIButton().then {
        $0.setTitle("캠퍼스 설정", for: .normal)
        $0.setTitleColor(UIColor.gray, for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(size: 12, family: .Regular)
        $0.addTarget(self, action: #selector(didTapCampusSetInfoButton), for: .touchUpInside)
    }
    
    @objc private func didTapCampusSetInfoButton() {
        let infoAlert = UIAlertController(title: "캠퍼스 설정이란?",
                                          message: "\n선택한 캠퍼스의 학식 정보를 제공해드려요! \n(이후 설정에서 변경 가능)",
                                          preferredStyle: .alert)
        infoAlert.addAction(UIAlertAction(title: "알겠어요", style: .default))
        present(infoAlert, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(titleImgView)
        campusButtonStackView.addSubview(seoulCampusButton)
        campusButtonStackView.addSubview(yonginCampusButton)
        self.view.addSubview(campusButtonStackView)
        self.view.addSubview(campusSetInfoButton)
        
        titleImgView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            if UIDevice().hasNotch { $0.top.equalToSuperview().offset(210) }
            else { $0.top.equalToSuperview().offset(140) }
        }
        
        campusButtonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleImgView.snp.bottom).offset(100)
            $0.leading.equalToSuperview().offset(48)
            $0.trailing.equalToSuperview().inset(48)
        }
        
        seoulCampusButton.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        yonginCampusButton.snp.makeConstraints {
            $0.top.equalTo(seoulCampusButton.snp.bottom).offset(15)
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        campusSetInfoButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(campusButtonStackView.snp.bottom).offset(10)
        }
        
        setButtonAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetButtonLayout()
    }
    
    
    private func resetButtonLayout() {
        [ seoulCampusButton, yonginCampusButton ].forEach {
            $0.backgroundColor = UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1)
            $0.setTitleColor(UIColor.white, for: .normal)
        }
    }
}

extension SplashViewController {
    private func setButtonAction() {
        seoulCampusButton.addTarget(self, action: #selector(didTapCampusButton), for: .touchUpInside)
        yonginCampusButton.addTarget(self, action: #selector(didTapCampusButton), for: .touchUpInside)
    }
    
    @objc private func didTapCampusButton(_ sender: UIButton) {
        print("\(sender.titleLabel?.text!) 버튼 클릭함")
        sender.layer.backgroundColor = UIColor.white.cgColor
        sender.layer.borderWidth = 1.7
        sender.layer.borderColor = UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1).cgColor
        sender.setTitleColor(UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1), for: .normal)
        
        // TODO: 커스텀 팝업 뷰 띄우기
        let alertViewController = CampusSetPopupViewController()
        alertViewController.emphasisText = (sender.titleLabel)!.text!
        alertViewController.fullText = "로 \n캠퍼스 설정을 하시겠어요?"
        alertViewController.modalPresentationStyle = .fullScreen
        present(alertViewController, animated: true)
    }
}
