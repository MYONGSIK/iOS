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
            MainViewModel.shared.setCampus(campus: CampusInfo.seoul.name)
        case CampusInfo.yongin.name:
            MainViewModel.shared.setCampus(campus: CampusInfo.yongin.name)
        default:
            print("ERROR :: fail to set campus")
            return
        }
        MainViewModel.shared.getCampus()
    }
    
    override func didTapCancelButton(_ sender: UIButton) {
        delegate?.resetButtonLayouts()
        super.didTapCancelButton(sender)
    }
}
