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
    
    // MARK: - Get Method
    func GetDataManager<T: Decodable>(with param: Encodable? = nil, from url: String, callback: @escaping (_ data: T?, _ error: String?) -> ()) {
        AF.request(url, method: .get, parameters: param?.dictionary).responseJSON { response in
            do {
                guard let resData = response.data else {
                    callback(nil, "emptyData")
                    return
                }
                let data = try JSONDecoder().decode(T.self, from:resData)
                callback(data, nil)
     
            } catch {
                callback(nil, error.localizedDescription)
            }
        }
    }
    // MARK: - Post Method
    func PostDataManager<T: Decodable>(with param: Encodable? = nil, from url: String, callback: @escaping (_ data: T?, _ error: String?) -> ()) {
        AF.request(url, method: .get, parameters: param?.dictionary).responseJSON { response in
            do {
                guard let resData = response.data else {
                    callback(nil, "emptyData")
                    return
                }
                let data = try JSONDecoder().decode(T.self, from:resData)
                callback(data, nil)
     
            } catch {
                callback(nil, error.localizedDescription)
            }
        }
    }
    
    func getData<T: Decodable>(urlEndpointString: String,
                               dataType: T.Type,
                               parameter: Parameters?,
                               completionHandler: @escaping (T)->Void) {
        
        let urlString = Constants.BaseURL + urlEndpointString
        if let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            guard let url = URL(string: encodedUrlString) else { return }
            
            AF
                .request(url, method: .get, parameters: parameter)
                .responseDecodable(of: T.self) { response in
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
    
    func postData<T: Codable, R: Decodable>(urlEndpointString: String,
                                            dataType: T.Type,
                                            responseType: R.Type,
                                            parameter: T,
                                            completionHandler: @escaping (APIModel<R>) -> Void) {
        
        guard let url = URL(string: Constants.BaseURL + urlEndpointString) else { return }

        AF
            .request(url,
                     method: .post,
                     parameters: parameter,
                     encoder: .json)
            .responseDecodable(of: APIModel<R>.self) { response in
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
