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
    
    func searchMapDataManager(_ keyword: String, _ viewcontroller: RestaurantSearchViewController) {
        let sendUrl = Constants.KakaoURL + Constants.keyword + "\(keyword)" + Constants.x + Constants.y + Constants.radius
        guard let target = sendUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let url = URL(string: target) else {return}

        AF.request(url, method: .get, parameters: nil, headers: headers)
           .validate()
           .responseDecodable(of: KakaoMapModel.self) { response in
               
           switch response.result {
           case .success(let result):
                viewcontroller.kakaoSearchMapSuccessAPI(result.documents)
           case .failure(let error):
               let statusCode = error.responseCode
               switch statusCode {
               case 404:
                   viewcontroller.kakaoSearchNoResultAPI()
               default:
                   fatalError()
               }
               print(error.localizedDescription)
           }
        }
    }
}
