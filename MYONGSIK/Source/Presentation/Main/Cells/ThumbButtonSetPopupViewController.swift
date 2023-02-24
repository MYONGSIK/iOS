//
//  ThumbButtonSetPopupViewController.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/02/24.
//

import UIKit

class ThumbButtonSetPopupViewController: PopupBaseVIewController {
    var data: DayFoodModel!
    var thumbUpButton: UIButton?
    var thumbDownButton: UIButton?
    
    override func didTapConfirmButton(_ sender: UIButton) {
        super.didTapConfirmButton(sender)
        guard let day = data.toDay else {return}
        guard let type = data.mealType else {return}
        
        switch super.emphasisText! {
        case "맛있어요":
            print("TODO: 맛있어요 POST")
            UserDefaults.standard.set(1, forKey: day+type)
            dismiss(animated: true)
        case "맛없어요":
            print("TODO: 맛없어요 POST")
            UserDefaults.standard.set(2, forKey: day+type)
            dismiss(animated: true)
        default:
            print("ERROR :: fail to set thumbs button action")
            return
        }
        setUpButtons()
        UIDevice.vibrate()
    }
    
    func setUpButtons() {
        guard let data = self.data else {return}
        guard let day = data.toDay else {return}
        guard let type = data.mealType else {return}
        
        var selected = 0
        
        if let type = data.mealType {
            selected = UserDefaults.standard.integer(forKey: day+type) ?? 0
        } else {
            selected = UserDefaults.standard.integer(forKey: day+type) ?? 0
        }

        switch selected {
        case 1:
            thumbUpButton?.isSelected = true
            thumbDownButton?.isSelected = false
        case 2:
            thumbUpButton?.isSelected = false
            thumbDownButton?.isSelected = true
        default:
            thumbUpButton?.isSelected = false
            thumbDownButton?.isSelected = false
        }

        if let thumbUpButton = thumbUpButton,
           let thumbDownButton = thumbDownButton {
            thumbUpButton.titleLabel?.textColor = thumbUpButton.isSelected ? .signatureBlue : .signatureGray
            thumbDownButton.titleLabel?.textColor = thumbDownButton.isSelected ? .signatureBlue : .signatureGray
            
            thumbUpButton.titleLabel?.font = thumbUpButton.isSelected ? UIFont.NotoSansKR(size: 12, family: .Bold) : UIFont.NotoSansKR(size: 12, family: .Regular)
            thumbDownButton.titleLabel?.font = thumbDownButton.isSelected ? UIFont.NotoSansKR(size: 12, family: .Bold) : UIFont.NotoSansKR(size: 12, family: .Regular)
        }
        
    }
}

