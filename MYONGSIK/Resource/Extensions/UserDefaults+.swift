//
//  UserDefaults+.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/04/22.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.MYONGSIK"
        return UserDefaults(suiteName: appGroupId)!
    }
}
