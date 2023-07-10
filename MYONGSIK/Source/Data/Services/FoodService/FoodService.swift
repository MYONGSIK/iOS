//
//  FoodService.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/06/05.
//

import Foundation

class FoodService {
    
    func getAllFood(area: String, completion: @escaping ([DayFoodModel]?) -> Void) {
        APIManager.shared.getData(urlEndpointString: "/api/v2/meals/week/\(area)", dataType: APIModel<[DayFoodModel]>.self , parameter: nil) { response in
            completion(response.data)
        }
    }
    
    
    func postReview(area: String, param: SubmitModel, completion: @escaping (Bool) -> Void) {
        APIManager.shared.postData(urlEndpointString: Constants.postFoodReviewWithArea, dataType: SubmitModel.self, responseType: SubmitResponseModel.self, parameter: param) { response in
            if response.httpCode == 200 {
                completion(true)
            }else {
                completion(false)
            }
        }
    }
    
}


