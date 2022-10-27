//
//  DayFoodManager.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/19.
//

import Foundation
import Alamofire
import SwiftUI

class DayFoodDataManager {
    static let shared = DayFoodDataManager()
    
    // MARK: - 주 간 조회
    func getWeekFoodDataManager(_ viewcontroller: WeekViewController) {
        APIManager().GetDataManager(from: Constants.BaseURL + Constants.getWeekFood) { (data: APIModel<[WeekFoodModel]>?, error) in
            guard let data = data else {print("error: \(error?.debugDescription)"); return}
            switch data.success {
            case true:
                viewcontroller.getWeekFoodAPISuccess(data.data!)
            default:
                fatalError()
            }
        }
    }
}
