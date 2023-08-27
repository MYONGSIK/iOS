//
//  FoodService.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/06/05.
//

import Foundation

class MainService {
    func getWeekFood(area: String, completion: @escaping (APIModel<[DayFoodModel]>) -> Void) {
        APIManager.shared.getData(urlEndpointString: "/api/v2/meals/week/\(area)", dataType: APIModel<[DayFoodModel]>.self , parameter: nil) { response in
            completion(response)
        }
    }
    
    func setCampus(campus: String) {
        UserDefaults.standard.setValue(campus, forKey: "userCampus")
    }
    
    func getCampus(completion: @escaping (String) -> Void) {
        if let campus = UserDefaults.standard.object(forKey: "userCampus") as? String {
            completion(campus)
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


