//
//  CampusSetPopupViewController.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/02/20.
//

import UIKit

class CampusSetPopupViewController: PopupBaseVIewController {    
    override func didTapConfirmButton(_ sender: UIButton) {
        super.didTapConfirmButton(sender)
        
        switch super.emphasisText! {
        case CampusInfo.seoul.name:
            UserDefaults.standard.set(CampusInfo.seoul.name, forKey: "userCampus")
        case CampusInfo.yongin.name:
            UserDefaults.standard.set(CampusInfo.yongin.name, forKey: "userCampus")
        default:
            print("ERROR :: fail to set campus")
            return
        }
//        print("선택된 캠퍼스 : \(UserDefaults.standard.value(forKey: "userCampus")!)")

        let main = TabBarViewController()
        main.modalPresentationStyle = .fullScreen
        present(main, animated: true)
    }
}
