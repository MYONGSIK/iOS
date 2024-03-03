//
//  FoodService.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/06/05.
//

import Foundation

protocol MainServiceProtocol {
    func getWeekFood(area: String, completion: @escaping ([DayFoodModel]) -> Void)
    func setWidgetResName(resName: String)
    func getWidgetResName(completion: @escaping (String?) -> Void)
}

class MainService: MainServiceProtocol {
    func getWeekFood(area: String, completion: @escaping ([DayFoodModel]) -> Void) {
        APIManager.shared.getData(urlEndpointString: "/api/v2/meals/week/\(area)", responseDataType: [DayFoodModel].self, parameter: nil) { response in
            if let data = response.data {
                completion(data)
            }
        }
    }
    
    func setWidgetResName(resName: String) {
        UserDefaults.standard.setValue(resName, forKey: "widget_res_name")
    }
    
    func getWidgetResName(completion: @escaping (String?) -> Void) {
        completion(UserDefaults.standard.object(forKey: "widget_res_name") as? String)
    }
}


