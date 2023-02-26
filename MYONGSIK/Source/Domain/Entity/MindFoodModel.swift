//
//  MindFoodModel.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/02/24.
//

import Foundation

enum EvaluationType: String {
    case love = "LOVE"
    case hate = "HATE"
}

enum Calculation: String {
    case plus = "plus"
    case minus = "minus"
}

struct MindFoolRequestModel: Codable {
    let calculation: String?
    let mealEvaluate: String?
    let mealId: Int?
}
