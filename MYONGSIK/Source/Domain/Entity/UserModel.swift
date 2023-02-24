//
//  UserModel.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/02/24.
//

import Foundation

struct UserModel: Codable {
    let phoneId: String
}

struct UserResponseModel: Codable {
    let id: Int?
    let phoneId: String
}
