//
//  ThumbButtonSetPopupViewController.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/02/24.
//

import UIKit
import Alamofire

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
            postMindFood(isLike: true)  // 맛있어요 POST
        case "맛없어요":
            print("TODO: 맛없어요 POST")
            UserDefaults.standard.set(2, forKey: day+type)
            postMindFood(isLike: false)  // 맛없어요 POST
        default:
            print("ERROR :: fail to set thumbs button action")
            return
        }
        setUpButtons()
        UIDevice.vibrate()
        
        dismiss(animated: true)
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

extension ThumbButtonSetPopupViewController {
    private func postMindFood(isLike: Bool) {
        var param: MindFoolRequestModel?
        if isLike {
            param = MindFoolRequestModel(calculation: "plus",
                                             mealEvaluate: "LOVE",
                                             mealId: data.mealId)

        } else {
            param = MindFoolRequestModel(calculation: "plus",
                                             mealEvaluate: "HATE",
                                             mealId: data.mealId)
        }
        
        APIManager.shared.postData(urlEndpointString: "/api/v2/meals/evaluate",
                                   dataType: MindFoolRequestModel.self,
                                   responseType: Bool.self,
                                   parameter: param!,
                                   completionHandler: { result in
            print(result.message)
            
        })
    }
}

