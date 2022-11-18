//
//  APIManager.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/27.
//
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
