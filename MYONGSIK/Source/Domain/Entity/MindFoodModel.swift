//
//  MindFoodModel.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/02/24.
//

import Foundation


//{
//  "calculation": "plus/minus",
//  "mealEvaluate": "LOVE/HATE",
//  "mealId": 0
//}

struct MindFoolRequestModel: Codable {
    let calculation: String?
    let mealEvaluate: String?
    let mealId: Int?
}
