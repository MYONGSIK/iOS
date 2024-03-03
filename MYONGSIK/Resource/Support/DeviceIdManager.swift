//
//  RegisterUUID.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/02/24.
//

import Foundation
import Security
import UIKit

class DeviceIdManager {
    static let shared = DeviceIdManager()
    
    private let account = "ServiceSaveKey"
    private let service = Bundle.main.bundleIdentifier
    
    private var _deviceId: String = ""
    
    var deviceId: String {
        get {
            return _deviceId
        }
        set(value) {
            _deviceId = value
        }
    }
    
    func createDeviceID() -> Bool {
        guard let service = self.service else {return false}

        let deviceID = self.setDeviceID()

        let query:[CFString: Any]=[kSecClass: kSecClassGenericPassword,
                                   kSecAttrService: service,
                                   kSecAttrAccount: account,
                                   kSecValueData: deviceID.data(using: .utf8, allowLossyConversion: false)!]
        
        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            self.deviceId = deviceID
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
            
            print("get : "  + uuidData)
            
            deviceId = uuidData
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
        APIManager.shared.postData(urlEndpointString: Constants.registerUser, responseDataType: UserModel.self, requestDataType: UserModel.self, parameter: param) { result in
            switch result.success {
            case true:
                print("유저 등록 성공 :: UUID - \(param.phoneId)")
            case false:
                print("유저 등록 실패 (result.success is FALSE, error code: \(String(describing: result.httpCode))")
            }
        }
    }
}

