//
//  HeartService.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/06/05.
//

import Foundation
import Combine

protocol HeartServiceProtocol {
    func getHeartList() -> [ResponseHeartModel]
    func postHeart(heart: RequestHeartModel) -> Bool
    func cancelHeart(id: String) -> Bool
}

class HeartService: HeartServiceProtocol {
    private let apiManager = APIManager.shared
    
    func getHeartList() -> [ResponseHeartModel] {
        var heartList: [ResponseHeartModel] = []
        
        apiManager.getData(urlEndpointString: Constants.GetHeartUrl, responseDataType: ListModel<ResponseHeartModel>.self, parameter: nil) { response in
            if let result = response.data?.content {
                heartList = result
            }
        }
        
        return heartList
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
