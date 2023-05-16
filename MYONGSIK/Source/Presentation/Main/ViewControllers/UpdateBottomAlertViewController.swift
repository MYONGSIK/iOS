//
//  UpdateBottomAlertViewController.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/04/24.
//

import UIKit

class UpdateBottomAlertViewController: UIViewController {
    
    let bottomView = UIView().then {
        $0.backgroundColor = .white
        
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.masksToBounds = true
        
        $0.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 40
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    let widgetBorderView = UIView().then {
        $0.layer.cornerRadius = 20
        $0.layer.borderColor = CGColor(red: 8 / 255, green: 66 / 255, blue: 189 / 255, alpha: 1)
        $0.layer.borderWidth = 1.3
    }
    
    let widgetImageView = UIImageView().then {
        $0.image = UIImage(named: "update_widget")
    }
    
    let widgetTitleLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(size: 13, family: .Regular)
        $0.textColor = UIColor(red: 37 / 255, green: 87 / 255, blue: 201 / 255, alpha: 1)
        $0.text = "위젯 설정"
    }
    
    let widgetContentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.NotoSansKR(size: 12, family: .Regular)
        $0.textColor = UIColor(red: 105 / 255, green: 97 / 255, blue: 97 / 255, alpha: 1)
        $0.text = "앱을 접속하지 않고도 원하는 식당 한곳을 \n설정하여 위젯으로 메뉴를 확인할 수 있어요!"
    }
    
    let mapBorderView = UIView().then {
        $0.layer.cornerRadius = 20
        $0.layer.borderColor = CGColor(red: 8 / 255, green: 66 / 255, blue: 189 / 255, alpha: 1)
        $0.layer.borderWidth = 1.3
    }
    
    let mapImageView = UIImageView().then {
        $0.image = UIImage(named: "update_map")
    }
    
    
    let mapTitleLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(size: 13, family: .Regular)
        $0.textColor = UIColor(red: 37 / 255, green: 87 / 255, blue: 201 / 255, alpha: 1)
        $0.text = "맛집 지도"
    }
    
    let mapContentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.NotoSansKR(size: 12, family: .Regular)
        $0.textColor = UIColor(red: 105 / 255, green: 97 / 255, blue: 97 / 255, alpha: 1)
        $0.text = "명지대학교 학생들이 선택한 인증된 맛집을\n지도로 한 눈에 확인할 수 있어요!"
    }
    
    let stopButton = UIButton().then {
        $0.layer.cornerRadius = 6
        $0.addTarget(self, action: #selector(stopAlert), for: .touchUpInside)
        $0.backgroundColor = UIColor(red: 37 / 255, green: 87 / 255, blue: 201 / 255, alpha: 1)
        $0.tintColor = .white
        $0.titleLabel?.font = UIFont.NotoSansKR(size: 18, family: .Regular)
        $0.setTitle("다시 보지 않기", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    
    func setupLayout() {
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        let height = UIScreen.main.bounds.height
        
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.height.equalTo(height/2 + 40)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        bottomView.addSubview(widgetBorderView)
        widgetBorderView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(51)
            make.leading.equalToSuperview().offset(31)
            make.width.equalTo(70)
            make.height.equalTo(70)
        }
        
        widgetBorderView.addSubview(widgetImageView)
        widgetImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(6)
            make.bottom.equalToSuperview().inset(16)
        }
        
        bottomView.addSubview(widgetTitleLabel)
        widgetTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(51)
            make.leading.equalTo(widgetBorderView.snp.trailing).offset(32)
            make.height.equalTo(19)
        }
        
        bottomView.addSubview(widgetContentLabel)
        widgetContentLabel.snp.makeConstraints { make in
            make.top.equalTo(widgetTitleLabel.snp.bottom).offset(4)
            make.leading.equalTo(widgetBorderView.snp.trailing).offset(34)
            make.width.equalTo(217)
        }
        
        
        bottomView.addSubview(mapBorderView)
        mapBorderView.snp.makeConstraints { make in
            make.top.equalTo(widgetBorderView.snp.bottom).offset(62)
            make.leading.equalToSuperview().offset(31)
            make.width.equalTo(70)
            make.height.equalTo(70)
        }
        
        mapBorderView.addSubview(mapImageView)
        mapImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(16)
        }
        
        bottomView.addSubview(mapTitleLabel)
        mapTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(widgetContentLabel.snp.bottom).offset(75)
            make.leading.equalTo(mapBorderView.snp.trailing).offset(32)
            make.height.equalTo(19)
        }
        
        bottomView.addSubview(mapContentLabel)
        mapContentLabel.snp.makeConstraints { make in
            make.top.equalTo(mapTitleLabel.snp.bottom).offset(4)
            make.leading.equalTo(mapBorderView.snp.trailing).offset(34)
            make.width.equalTo(217)
        }
        
        
        bottomView.addSubview(stopButton)
        stopButton.snp.makeConstraints { make in
            make.top.equalTo(mapBorderView.snp.bottom).offset(48)
            make.centerX.equalToSuperview()
            make.width.equalTo(354)
            make.height.equalTo(51)
        }
    }
    
    
    @objc func stopAlert() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(true) {
            UserDefaults.standard.setValue(encoded, forKey: "StopAlert")
        }
        self.dismiss(animated: true)
    }
    

}
