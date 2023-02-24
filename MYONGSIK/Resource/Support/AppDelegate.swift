//
//  AppDelegate.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/18.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: LaunchScreen
        // 각 상황별로 실행할 작업을 클로저 내에 작성
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        checkAppFirstrunOrUpdateStatus {
//            print("앱 설치 후 최초 실행할때만 실행됨")
            print("앱 설치 후 최초 UUID - \(uuid)")
            registerUser(uuid: uuid)
            // TODO: user register by uuid
        } updated: {
//            print("버전 변경시마다 실행됨")
            print("앱 버전 변경 후 최초 UUID - \(uuid)")
            registerUser(uuid: uuid)
            // TODO: user register by uuid
//            registerUser(uuid: uuid)
        } nothingChanged: {
            print("변경 사항 없음")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

