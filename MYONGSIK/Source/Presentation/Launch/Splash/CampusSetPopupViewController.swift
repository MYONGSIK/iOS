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
            UserDefaults.standard.set(CampusInfo.seoul.name, forKey: "userCampus")
            UserDefaults.shared.set(CampusInfo.seoul.name, forKey: "userCampus")
        case CampusInfo.yongin.name:
            UserDefaults.standard.set(CampusInfo.yongin.name, forKey: "userCampus")
            UserDefaults.shared.set(CampusInfo.yongin.name, forKey: "userCampus")
        default:
            print("ERROR :: fail to set campus")
            return
        }

        let main = TabBarViewController()
        main.modalPresentationStyle = .fullScreen
        present(main, animated: true)
    }
    
    override func didTapCancelButton(_ sender: UIButton) {
        delegate?.resetButtonLayouts()
        super.didTapCancelButton(sender)
    }
}
