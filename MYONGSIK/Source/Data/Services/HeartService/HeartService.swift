//
//  HeartService.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/06/05.
//

import Foundation

protocol HeartServiceProtocol {
    func getHeartList(completion: @escaping ([ResponseHeartModel]) -> Void)
    func postHeart(heart: RequestHeartModel, completion: @escaping (ResponseHeartModel) -> Void)
    func cancelHeart(id: String)
}

class HeartService: HeartServiceProtocol {
    private let apiManager = APIManager.shared
    
    func getHeartList(completion: @escaping ([ResponseHeartModel]) -> Void) {
        apiManager.getData(urlEndpointString: Constants.GetHeartUrl, responseDataType: ListModel<ResponseHeartModel>.self, parameter: nil) { response in
            if let heartList = response.data?.content {
                completion(heartList)
            }
        }
    }
    
    func postHeart(heart: RequestHeartModel, completion: @escaping (ResponseHeartModel) -> Void) {
        apiManager.postData(urlEndpointString: Constants.HeartUrl, responseDataType: ResponseHeartModel.self, requestDataType: RequestHeartModel.self, parameter: heart) { response in
            if let heartResult = response.data {
                completion(heartResult)
            }
        }
    }
    
    func cancelHeart(id: String) {
        apiManager.deleteData(urlEndpointString: Constants.HeartUrl + "/\(id)", responseDataType: ResponseHeartModel.self, requestDataType: RequestHeartModel.self
                              , parameter: nil) {_ in }
    }
    
    
}
