//
//  DayFoodManager.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/19.
//

import Foundation
import Alamofire

class DayFoodDataManager {
    let BaseURL = UserDefaults.standard.string(forKey: "url") ?? ""
    
    // MARK: - 사용자 정보 조회
    func getDayFoodDataManager(_ viewcontroller: MainViewController) {
        AF.request(BaseURL + "/api/v1/foods",
                           method: .get,
                           parameters: nil,
                           headers: nil)
            .validate()
            .responseDecodable(of: APIModel<[DayFoodModel]>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.getDayFoodAPISuccess(result.data!)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                case 400:
                    viewcontroller.noFoodAPI()
                default:
                    print(error.localizedDescription)
                }
                print(error.localizedDescription)
            }
        }
    }
}
