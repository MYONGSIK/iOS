//
//  APIManager.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/27.
//
import Foundation
import Alamofire

// MARK: Generic을 활용한 네트워크 통신
class APIManager {
    static let shared = APIManager()
    
    private var campusInfo: CampusInfo = .seoul
    
    init() {
        if let userCampus  = UserDefaults.standard.value(forKey: "userCampus") {
            switch userCampus as! String {
            case CampusInfo.seoul.name:
                campusInfo = .seoul
            case CampusInfo.yongin.name:
                campusInfo = .yongin
            default:
                return
            }
        }
    }
    
    func getData<T: Decodable>(urlEndpointString: String,
                               responseDataType: T.Type,
                               parameter: Parameters?,
                               completionHandler: @escaping (APIModel<T>)->Void) {
        
        let urlString = Constants.BaseURL + urlEndpointString
        print("url -> \(urlString)")
        if let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            guard let url = URL(string: encodedUrlString) else { return }
            
            AF
                .request(url, method: .get, parameters: parameter, encoding: URLEncoding.queryString)
                .responseDecodable(of: APIModel<T>.self) { response in
                    print("getData called")
                    switch response.result {
                    case .success(let success):
                        completionHandler(success)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                .resume()
            
        } else { print("URL에 한글이 포함되어 있거나 그 외 오류 있으므로 인코딩 실패") }
        
    }
    
    func postData<T: Codable, U: Decodable>(urlEndpointString: String,
                                            responseDataType: U.Type,
                                            requestDataType: T.Type,
                                            parameter: T?,
                                            completionHandler: @escaping (APIModel<U>)->Void) {
        
        guard let url = URL(string: Constants.BaseURL + urlEndpointString) else { return }

        AF
            .request(url,
                     method: .post,
                     parameters: parameter,
                     encoder: .json)
            .responseDecodable(of: APIModel<U>.self) { response in
                print(response)
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
    
    func deleteData<T: Codable, U: Decodable>(urlEndpointString: String,
                                                responseDataType: U.Type,
                                                requestDataType: T.Type,
                                                parameter: T?,
                                                completionHandler: @escaping (APIModel<U>)->Void) {
            
        guard let url = URL(string: Constants.BaseURL + urlEndpointString) else { return }
            
            AF
                .request(url, method: .delete, parameters: parameter, encoder: .json)
                .responseDecodable(of: APIModel<U>.self) { response in

                    print(response)
                    switch response.result {
                    case .success(let success):
                        completionHandler(success)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                .resume()
        }
}

// MARK: - Encodable Extension
extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            print("Dictionary is nil")
            return nil
        }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
