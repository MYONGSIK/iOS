//
//  RestaurantService.swift
//  MYONGSIK
//
//  Created by 유상 on 2/23/24.
//

import Foundation
import Alamofire

protocol RestaurantServiceProtocol {
    func getRestaurantList(completion: @escaping ([RestaurantModel]) -> Void)
    func getKakaoRestaurantList(completion: @escaping ([KakaoResultModel]) -> Void)
    func getTagRestaurantList(keyword: String, completion: @escaping ([KakaoResultModel]) -> Void)
}

class RestaurantService: RestaurantServiceProtocol {
    
    private let headers: HTTPHeaders = [
        "Authorization": Constants.KakaoAuthorization,
        "Accept": "application/json"
    ]
    private let foodList = ["부대찌개", "국밥", "마라탕", "중식", "한식", "카페", "족발", "술집", "파스타", "커피", "삼겹살", "치킨", "떡볶이", "햄버거", "피자", "초밥", "회", "곱창", "냉면", "닭발"]
    private var campusInfo: CampusInfo = .seoul
    
    
    
    func getRestaurantList(completion: @escaping ([RestaurantModel]) -> Void) {
        APIManager.shared.getData(urlEndpointString: Constants.RestaurantUrl, responseDataType: ListModel<RestaurantModel>.self, parameter: nil) { response in
            if let content = response.data?.content {
                completion(content)
            }
        }
    }
    
    func getKakaoRestaurantList(completion: @escaping ([KakaoResultModel]) -> Void) {
        let randomKeyword = foodList.randomElement() ?? ""
        
        let radius = (campusInfo == .seoul) ? Constants.seoulRadius : Constants.yonginRadius
        let sendUrl = Constants.KakaoURL + campusInfo.keyword + "\(randomKeyword)"
                    + campusInfo.x + campusInfo.y + radius + Constants.categoryCode + Constants.sort
        guard let target = sendUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let url = URL(string: target) else {return}

        AF.request(url, method: .get, parameters: nil, headers: headers)
           .validate()
           .responseDecodable(of: KakaoMapModel.self) { response in
               
           switch response.result {
           case .success(let result):
               completion(result.documents)
           case .failure(let error):
               print(error.localizedDescription)
               fatalError()
           }
        }
    }
    
    func getTagRestaurantList(keyword: String, completion: @escaping ([KakaoResultModel]) -> Void) {
        let radius = (campusInfo == .seoul) ? Constants.seoulRadius : Constants.yonginRadius
        let sendUrl = Constants.KakaoURL + campusInfo.keyword + "\(keyword)"
                    + campusInfo.x + campusInfo.y + radius + Constants.categoryCode + Constants.sort
        guard let target = sendUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let url = URL(string: target) else {return}

        AF.request(url, method: .get, parameters: nil, headers: headers)
           .validate()
           .responseDecodable(of: KakaoMapModel.self) { response in
               
           switch response.result {
           case .success(let result):
               completion(result.documents)
           case .failure(let error):
               print(error.localizedDescription)
               fatalError()
           }
        }
    }
}
