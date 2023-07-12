//
//  FoodService.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/06/05.
//

import Foundation

class MainService {
    func getWeekFood(area: String, completion: @escaping ([DayFoodModel]) -> Void) {
        APIManager.shared.getData(urlEndpointString: "/api/v2/meals/week/\(area)", dataType: APIModel<[DayFoodModel]>.self , parameter: nil) { response in
            if let data = response.data {
                completion(data)
            }
        }
    }
    
}


