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
    func postHeart(heart: RequestHeartModel) -> Bool
    func cancelHeart(id: String) -> Bool
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
    
    func postHeart(heart: RequestHeartModel) -> Bool {
        var result: Bool = false
        apiManager.postData(urlEndpointString: Constants.HeartUrl, responseDataType: ResponseHeartModel.self, requestDataType: RequestHeartModel.self, parameter: heart) { response in
            result = response.success
        }
        
        return result
    }
    
    func cancelHeart(id: String) -> Bool {
        var result: Bool = false
        apiManager.deleteData(urlEndpointString: Constants.HeartUrl + "/\(id)", responseDataType: ResponseHeartModel.self, requestDataType: RequestHeartModel.self
                              , parameter: nil) { response in
            result = response.success
        }
        
        return result
        
    }
    
    
}
