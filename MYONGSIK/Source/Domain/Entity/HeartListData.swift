//
//  HeartListModel.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/02.
//

import Foundation

struct RequestHeartModel: Codable {
    var address: String! = "주소없음"
    var campus: String?
    var category: String?
    var code: String?
    var contact: String! = "전화번호없음"
    var distance: String?
    var longitude: String?  // 경도, x 
    var latitude: String?   // 위도, y
    var name: String?
    var phoneId: String?
    var urlAddress: String?
}

struct ResponseHeartModel: Codable {
    var id: Int
    var code: String?
    var name: String?
    var distance: String?
    var category: String?
    var address: String?
    var contact: String?
    var urlAddress: String?
    var latitude: String?
    var longitude: String?
}

