//
//  CampusSetPopupViewController.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/02/20.
//

import UIKit

protocol CampusSetPopupDelegate {
    func resetButtonLayouts()
}

class CampusSetPopupViewController: PopupBaseVIewController {
    var delegate: CampusSetPopupDelegate?
    
    override func didTapConfirmButton(_ sender: UIButton) {
        super.didTapConfirmButton(sender)
        
        switch super.emphasisText! {
        case CampusInfo.seoul.name:
            CampusManager.shared.campus = CampusInfo.seoul
        case CampusInfo.yongin.name:
            CampusManager.shared.campus = CampusInfo.yongin
        default:
            print("ERROR :: fail to set campus")
            return
        }
        
        let tapbarVC = TabBarViewController()
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        sceneDelegate.window?.rootViewController = tapbarVC
    }
    
    override func didTapCancelButton(_ sender: UIButton) {
        delegate?.resetButtonLayouts()
        super.didTapCancelButton(sender)
    }
}
