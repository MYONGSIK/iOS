//
//  CampusManager.swift
//  MYONGSIK
//
//  Created by 유상 on 2/26/24.
//

import Foundation

class CampusManager {
    static let shared = CampusManager()
    
    private var _campus: CampusInfo?
    
    var campus: CampusInfo? {
        get {
            return _campus
        }
        set(campus) {
            _campus = campus
            setCampus(campus: campus!.name)
        }
    }
    
    init() {
        if let userCampus  =  getCampus() {
            switch userCampus {
            case CampusInfo.seoul.name:
                campus = .seoul
            case CampusInfo.yongin.name:
                campus = .yongin
            default:
                return
            }
        }
    }
    
    
    private func setCampus(campus: String) {
        UserDefaults.standard.setValue(campus, forKey: "userCampus")
    }
    
    private func getCampus() -> String? {
        return UserDefaults.standard.object(forKey: "userCampus") as? String
    }
}
