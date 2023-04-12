//
//  SubmitData.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/01/17.
//

import Foundation
import RealmSwift

// MARK: 학식 의견 데이터 모델
class SubmitData: Object {
    @objc dynamic var submittedDate = Date()
    @objc dynamic var opinion = ""
}

struct SubmitModel: Codable {
//    let submittedDate: Date!
//    let opinion: String!
    let areaName: String
    let writerId: String
    let registeredAt: String
    let content: String
}

struct SubmitResponseModel: Codable {
    
}
