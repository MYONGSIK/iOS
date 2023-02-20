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
        case Campus.seoul.rawValue:
            UserDefaults.standard.set(Campus.seoul.rawValue, forKey: "userCampus")
        case Campus.yongin.rawValue:
            UserDefaults.standard.set(Campus.yongin.rawValue, forKey: "userCampus")
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
