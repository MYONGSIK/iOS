//
//  HeartListModel.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/02.
//

import Foundation
import RealmSwift

// MARK: 찜꽁리스트 데이터 모델
class HeartListData: Object {
    @objc dynamic var placeName = ""
    @objc dynamic var category = ""
    @objc dynamic var placeUrl = ""
}

struct HeartListModel {
    let placeName: String!
    let category: String!
    let placeUrl: String!
}

struct HeartModel: Codable {
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

struct Heart: Codable {
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

//{
//        "id": 222,
//        "code": "14631333",
//        "name": "베가보쌈",
//        "distance": "131",
//        "category": "음식점",
//        "address": "서울 서대문구 거북골로 33-4",
//        "contact": "02-372-8254",
//        "urlAddress": "http://place.map.kakao.com/14631333",
//        "latitude": "126.924013870389",
//        "longitude": "37.5792516250279"
//      },
