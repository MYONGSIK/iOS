//
//  Restaurant.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/08/25.
//

import Foundation

enum Restaurant: String, CaseIterable{
    case mcc = "MCC식당"
    case paulbassett = "폴바셋식당"
    case staff = "교직원식당"
    case dormitory = "생활관식당"
    case academy = "학관식당"
    case myungjin = "명진당식당"
}

extension Restaurant {
    func getServerName() -> String {
        switch self {
        case .paulbassett:
            return "폴바셋"
        case .academy:
            return "학생식당"
        default:
            return self.rawValue
        }
    }
    
    func getTime() -> String {
        switch self {
        case .staff:
            return "운영시간 \n중식 11:30~13:30  |  석식 17:30~18:30"
        case .dormitory:
            return "운영시간 \n중식 11:30~13:30  |  석식 17:00~18:30"
        case .academy:
            return "운영시간 \n조식 08:30~09:30  |  중식 10:00~15:00"
        case .myungjin:
            return "운영시간 \n백반 11:30~14:30 \n샐러드,볶음밥 10:00~15:00"
        default:
            return ""
        }
    }
    
    func getFoodInfoCount() -> Int {
        switch self {
        case .myungjin:
            return 2
        default:
            return 3
        }
    }
}
