//
//  PopupBaseVIewController.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/02/20.
//

import Foundation
import UIKit

class PopupBaseVIewController: UIViewController {

    var emphasisText: String? = ""
    var fullText: String? = ""
    
    let alertSettingView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.layer.backgroundColor = UIColor.white.cgColor
    }
    
    lazy var alertLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(size: 16, family: .Regular)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        
        $0.attributedText = (emphasisText! + fullText!)
            .attributed(of: emphasisText!, value: [
                .foregroundColor: UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1),
                .font: UIFont.NotoSansKR(size: 16, family: .Bold)
            ])
    }
    
    let horizontalSeparator = UIView().then {  $0.backgroundColor = .signatureBlue }
    let verticalSeparator = UIView().then { $0.backgroundColor = .signatureBlue }
    
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    
    let confirmButtonView = UIView()
    let cancelButtonView = UIView()
    
    let confirmButton = UIButton().then {
        $0.setTitle("네", for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(size: 16, family: .Bold)
        $0.setTitleColor(UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1), for: .normal)
        
        $0.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
    }
    
    
    let cancelButton = UIButton().then {
        $0.setTitle("아니오", for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(size: 16, family: .Bold)
        $0.setTitleColor(UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1), for: .normal)

        $0.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
        self.view.addSubview(alertSettingView)
        alertSettingView.addSubview(alertLabel)
        
        alertSettingView.addSubview(buttonStackView)
        
        alertSettingView.addSubview(horizontalSeparator)
        buttonStackView.addSubview(verticalSeparator)

        buttonStackView.addSubview(confirmButtonView)
        confirmButtonView.addSubview(confirmButton)
        
        buttonStackView.addSubview(cancelButtonView)
        cancelButtonView.addSubview(cancelButton)


        alertSettingView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(200)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        alertLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(50)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        horizontalSeparator.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(buttonStackView.snp.top)
            $0.height.equalTo(1)
        }
        
        verticalSeparator.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        
        confirmButtonView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalTo(verticalSeparator.snp.leading)
        }
        confirmButton.snp.makeConstraints {
            $0.top.bottom.leading.trailing.bottom.equalToSuperview()
        }
        
        cancelButtonView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(verticalSeparator.snp.trailing)
        }
        cancelButton.snp.makeConstraints {
            $0.top.bottom.leading.trailing.bottom.equalToSuperview()
        }
        
    }
}

extension PopupBaseVIewController {
    
    @objc func didTapConfirmButton(_ sender: UIButton) {
        sender.backgroundColor = UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1)
        sender.setTitleColor(UIColor.white, for: .normal)
        
        // detail needs to be written by overriding
    }
    
    
    @objc func didTapCancelButton(_ sender: UIButton) {
        sender.backgroundColor = UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1)
        sender.setTitleColor(UIColor.white, for: .normal)
        dismiss(animated: true)
        
        // detail needs to be written by overriding
    }
}
