//
//  FoodService.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/06/05.
//

import Foundation

class MainService {
    func getWeekFood(area: String, completion: @escaping (APIModel<[DayFoodModel]>) -> Void) {
        APIManager.shared.getData(urlEndpointString: "/api/v2/meals/week/\(area)", responseDataType: APIModel<[DayFoodModel]>.self, parameter: nil) { response in
            if let data = response.data {
                completion(data)
            }
        }
    }
    
    func setWidgetResName(resName: String) {
        UserDefaults.standard.setValue(resName, forKey: "widget_res_name")
    }
    
    func getWidgetResName(completion: @escaping (String) -> Void) {
        if let resName = UserDefaults.standard.object(forKey: "widget_res_name") as? String {
            completion(resName)
        }
    }
}


