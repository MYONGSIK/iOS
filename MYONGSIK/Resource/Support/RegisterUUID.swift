//
//  RegisterUUID.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/02/24.
//

import Foundation
import Security
import UIKit

class RegisterUUID {
    static let shared = RegisterUUID()
    
    private let account = "ServiceSaveKey"
    private let service = Bundle.main.bundleIdentifier
    
    func createDeviceID() -> Bool {
        guard let service = self.service else {return false}

        let deviceID = self.setDeviceID()

        let query:[CFString: Any]=[kSecClass: kSecClassGenericPassword,
                                   kSecAttrService: service,
                                   kSecAttrAccount: account,
                                   kSecValueData: deviceID.data(using: .utf8, allowLossyConversion: false)!]
        
        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            registerUser(uuid: deviceID)
            return true
        }
        else {
            return false
        }
    }
    
    func getDeviceID() -> String {
        guard let service = self.service else {return ""}

        let query:[CFString: Any]=[kSecClass: kSecClassGenericPassword,
                                   kSecAttrService: service,
                                   kSecAttrAccount : account,
                                   kSecReturnData : true,
                                   kSecReturnAttributes: true,
                                   kSecMatchLimit : kSecMatchLimitOne]

        var dataTypeRef : CFTypeRef?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            guard let existingItem = dataTypeRef as? [String: Any] else {return ""}
            
            let deviceData = existingItem[kSecValueData as String] as? Foundation.Data
            let uuidData = String(data: deviceData!, encoding: .utf8)!
            
            return uuidData
        }
        else if status == errSecItemNotFound || status == -25300 {
            return ""
        }
        else {
            return ""
        }
    }
    
    
    func setDeviceID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    func registerUser(uuid: String) {
        let param = UserModel(phoneId: uuid)
        APIManager.shared.postData(urlEndpointString: Constants.registerUser,
                                   dataType: UserModel.self,
                                   responseType: APIModel<UserModel>.self,
                                   parameter: param,
                                   completionHandler: { result in
            
            switch result.success {
            case true:
                print("유저 등록 성공 :: UUID - \(param.phoneId)")
            case false:
                print("유저 등록 실패 (result.success is FALSE, error code: \(result.httpCode)")
            default:
                print("유저 등록 실패 (unknown error)")
            }
        })
    }
}

