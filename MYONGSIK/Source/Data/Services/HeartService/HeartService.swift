//
//  HeartService.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/06/05.
//

import Foundation
import Combine

protocol HeartServiceProtocol {
    func getHeartList(completion: @escaping ([ResponseHeartModel]) -> Void)
    func postHeart(heart: RequestHeartModel, completion: @escaping (ResponseHeartModel) -> Void)
    func cancelHeart(id: String, completion: @escaping (Bool) -> Void)
}

class HeartService: HeartServiceProtocol {
    private let apiManager = APIManager.shared
    
    func getHeartList(completion: @escaping ([ResponseHeartModel]) -> Void) {
        apiManager.getData(urlEndpointString: Constants.GetHeartUrl, responseDataType: ListModel<ResponseHeartModel>.self, parameter: nil) { response in
            if let result = response.data?.content {
                completion(result)
            }
        }
    }
    
    func postHeart(heart: RequestHeartModel, completion: @escaping (ResponseHeartModel) -> Void){
        apiManager.postData(urlEndpointString: Constants.HeartUrl, responseDataType: ResponseHeartModel.self, requestDataType: RequestHeartModel.self, parameter: heart) { response in
            if let result = response.data {
                completion(result)
            }
        }
    }
    
    func cancelHeart(id: String, completion: @escaping (Bool) -> Void) {
        apiManager.deleteData(urlEndpointString: Constants.HeartUrl + "/\(id)", responseDataType: ResponseHeartModel.self, requestDataType: RequestHeartModel.self
                              , parameter: nil) { response in
             completion(response.success)
        }
    }
    
    
}
