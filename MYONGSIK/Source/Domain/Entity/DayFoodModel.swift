//
//  DayFoodModel.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/19.
//

// MARK: 일간 학식 모델
enum MealType: String {
    case lunch_a = "LUNCH_A"
    case lunch_b = "LUNCH_B"
    case dinner = "DINNER"
}

struct DayFoodModel: Decodable {
    let mealId: Int
    let mealType: String
    let meals: [String]
    let statusType: String?
    let toDay: String?
}

// MARK: 주간 학식 모델
struct WeekFoodModel: Decodable {
    let toDay: String?
    let status: String?
    let dayOfTheWeek: String?
    let lunchA: [String]?
    let lunchB: [String]?
    let dinner: [String]?
}
