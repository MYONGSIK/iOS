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
    let kakaoURL = "https://dapi.kakao.com/v2/local/search/keyword.json?query="
    let headers: HTTPHeaders = [
                "Authorization": "KakaoAK " + "1167b82f504027f5cbddb0ba44492329",
                "Accept": "application/json"
            ]
    
    func searchMapDataManager(_ keyword: String, _ viewcontroller: RestaurantViewController) {
        let sendUrl = kakaoURL + "\(keyword)"
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
