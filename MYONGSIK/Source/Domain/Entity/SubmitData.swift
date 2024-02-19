//
//  SubmitData.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/01/17.
//

import Foundation

// MARK: 학식 의견 데이터 모델

struct SubmitModel: Codable {
    let areaName: String
    let writerId: String
    let registeredAt: String
    let content: String
}

struct SubmitResponseModel: Codable {
    
}
