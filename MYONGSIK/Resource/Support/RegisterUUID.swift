//
//  RegisterUUID.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/02/24.
//

import Foundation

func checkAppFirstrunOrUpdateStatus(firstrun: () -> (), updated: () -> (), nothingChanged: () -> ()) {
    let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    let versionOfLastRun = UserDefaults.standard.object(forKey: "VersionOfLastRun") as? String
    // print(#function, currentVersion ?? "", versionOfLastRun ?? "")
    if versionOfLastRun == nil {
        // First start after installing the app
        firstrun()
    } else if versionOfLastRun != currentVersion {
        // App was updated since last run
        updated()
    } else {
        // nothing changed
        nothingChanged()
    }
    UserDefaults.standard.set(currentVersion, forKey: "VersionOfLastRun")
    UserDefaults.standard.synchronize()
}

func registerUser(uuid: String) {
    let param = UserModel(phoneId: uuid)
    APIManager.shared.postData(urlEndpointString: "/api/v2/users",
                               dataType: UserModel.self,
                               responseType: APIModel<UserModel>.self,
                               parameter: param,
                               completionHandler: { result in
        
//        switch result.success {
//        case true:
//            UserDefaults.standard.set(result.data?.phoneId, forKey: "phoneId")
//            print("유저 등록 성공 :: UUID - \(UserDefaults.standard.value(forKey: "phoneId") as! String)")
//        case false:
//            print("유저 등록 실패 (result.success is FALSE)")
//        default:
//            print("유저 등록 실패 (unknown error)")
//        }
    })
}
