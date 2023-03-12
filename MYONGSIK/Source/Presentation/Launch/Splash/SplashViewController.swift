//
//  SplashViewController.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/02/20.
//

import UIKit
import SnapKit


enum SeoulRestaurant: String {
    case mcc = "MCC식당"
}

enum YonginRestaurant: String {
    case staff = "교직원식당"
    case dormitory = "생활관식당"
    case academy = "학관식당"
    case myungjin = "명진당식당"
}

class SplashViewController: UIViewController {
    
    let titleImgView = UIImageView().then {
        $0.image = UIImage(named: "splashTitle")
        $0.clipsToBounds = true
    }
    
    let campusButtonStackView = UIStackView()
    
    let seoulCampusButton = UIButton().then {
        $0.setTitle(CampusInfo.seoul.name, for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(size: 16, family: .Bold)
        $0.layer.backgroundColor = UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1).cgColor
        $0.layer.cornerRadius = 25
    }
    
    let yonginCampusButton = UIButton().then {
        $0.setTitle(CampusInfo.yongin.name, for: .normal)
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
                                          message: "\n선택한 캠퍼스의 학식과 주변 맛집 정보를 제공해드려요!",
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
            $0.centerY.equalToSuperview().offset(-105)
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
    
    // MARK: 홈 화면에 캠퍼스 설정 버튼 추가 이전에 사용되는 임시 경고창
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let alert = UIAlertController(title: "⚠️캠퍼스 설정 안내⚠️", message: "\n최초로 설정된 캠퍼스 설정은 이후 변경이 어려우니, 신중하게 골라주세요! ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

extension SplashViewController {
    private func setButtonAction() {
        seoulCampusButton.addTarget(self, action: #selector(didTapCampusButton), for: .touchUpInside)
        yonginCampusButton.addTarget(self, action: #selector(didTapCampusButton), for: .touchUpInside)
    }
    
    @objc private func didTapCampusButton(_ sender: UIButton) {
        sender.layer.backgroundColor = UIColor.white.cgColor
        sender.layer.borderWidth = 1.7
        sender.layer.borderColor = UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1).cgColor
        sender.setTitleColor(UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1), for: .normal)
        
        // TODO: 커스텀 팝업 뷰 띄우기
        let alertViewController = CampusSetPopupViewController()
        alertViewController.emphasisText = (sender.titleLabel)!.text!
        alertViewController.fullText = "로 \n캠퍼스 설정을 하시겠어요?"
        alertViewController.delegate = self
        alertViewController.modalPresentationStyle = .overCurrentContext
        present(alertViewController, animated: true)
    }
}

extension SplashViewController: CampusSetPopupDelegate {
    func resetButtonLayouts() {
        [ seoulCampusButton, yonginCampusButton ].forEach {
            $0.backgroundColor = UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1)
            $0.setTitleColor(UIColor.white, for: .normal)
        }
    }
}
