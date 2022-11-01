//
//  KakaoMapDataManager.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import Foundation
import Alamofire
import Kingfisher

class KakaoMapDataManager {
    let headers: HTTPHeaders = [
        "Authorization": Constants.KakaoAuthorization,
        "Accept": "application/json"
    ]
    
    func searchMapDataManager(_ keyword: String, _ viewcontroller: RestaurantViewController) {
        let sendUrl = Constants.KakaoURL + "\(keyword)"
        guard let target = sendUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let url = URL(string: target) else {return}

        AF.request(url, method: .get, parameters: nil, headers: headers)
           .validate()
           .responseDecodable(of: KakaoMapModel.self) { response in
               
           switch response.result {
           case .success(let result):
                        print("DEBUG: ", result)
//               viewcontroller.kakaoSearchBookSuccessAPI(result)
           case .failure(let error):
               print(error.localizedDescription)
           }
        }
    }
}
