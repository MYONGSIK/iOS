//
//  DayFoodModel.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/19.
//

// MARK: 일간 학식 모델
struct DayFoodModel: Decodable {
    let toDay: String?
    let dayOfTheWeek: String?
    let classification: String?
    let type: String?
    let status: String?
    let food1: String?
    let food2: String?
    let food3: String?
    let food4: String?
    let food5: String?
    let food6: String?
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
