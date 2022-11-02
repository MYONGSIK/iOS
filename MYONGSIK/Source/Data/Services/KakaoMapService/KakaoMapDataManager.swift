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
    private let foodList = ["부대찌개", "국밥", "마라탕", "중식", "한식", "카페", "족발", "술집", "파스타", "커피", "삼겹살", "치킨", "떡볶이", "햄버거", "피자", "초밥", "회", "곱창", "냉면", "닭발"]
    
    func searchMapDataManager(_ keyword: String, _ page: Int, _ viewcontroller: RestaurantSearchViewController) {
        let sendUrl = Constants.KakaoURL + Constants.keyword + "\(keyword)"
                    + Constants.x + Constants.y + Constants.radius + Constants.categoryCode
                    + Constants.page + "\(page)" + Constants.size + Constants.sort
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
               case 400, 404:
                   viewcontroller.kakaoSearchNoResultAPI()
               default:
                   print(error.localizedDescription)
                   fatalError()
               }
               print(error.localizedDescription)
           }
        }
    }
    func randomMapDataManager(_ viewcontroller: RestaurantMainViewController) {
        let randomKeyword = foodList.randomElement() ?? ""
        
        let sendUrl = Constants.KakaoURL + Constants.keyword + "\(randomKeyword)"
                    + Constants.x + Constants.y + Constants.radius + Constants.categoryCode + Constants.sort
        guard let target = sendUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let url = URL(string: target) else {return}

        AF.request(url, method: .get, parameters: nil, headers: headers)
           .validate()
           .responseDecodable(of: KakaoMapModel.self) { response in
               
           switch response.result {
           case .success(let result):
                viewcontroller.kakaoRandomMapSuccessAPI(result.documents)
           case .failure(let error):
               let statusCode = error.responseCode
               switch statusCode {
               case 400, 404:
                   viewcontroller.kakaoRandomNoResultAPI()
               default:
                   print(error.localizedDescription)
                   fatalError()
               }
               print(error.localizedDescription)
           }
        }
    }
    func tagMapDataManager(_ keyword: String, _ viewcontroller: RestaurantTagViewController) {
        let sendUrl = Constants.KakaoURL + Constants.keyword + "\(keyword)"
                    + Constants.x + Constants.y + Constants.radius + Constants.categoryCode + Constants.sort
        guard let target = sendUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let url = URL(string: target) else {return}

        AF.request(url, method: .get, parameters: nil, headers: headers)
           .validate()
           .responseDecodable(of: KakaoMapModel.self) { response in
               
           switch response.result {
           case .success(let result):
                viewcontroller.kakaoTagMapSuccessAPI(result.documents)
           case .failure(let error):
               let statusCode = error.responseCode
               switch statusCode {
               case 400, 404:
                   viewcontroller.kakaoTagNoResultAPI()
               default:
                   print(error.localizedDescription)
                   fatalError()
               }
               print(error.localizedDescription)
           }
        }
    }
}
