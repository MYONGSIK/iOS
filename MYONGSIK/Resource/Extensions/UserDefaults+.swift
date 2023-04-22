//
//  UserDefaults+.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/04/22.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
//        UserDefaults.standard.dictionaryRepresentation().forEach { (key, value) in
//            UserDefaults.shared.set(value, forKey: key)
//        }
        let appGroupId = "group.MYONGSIK"
        return UserDefaults(suiteName: appGroupId)!
    }
}
