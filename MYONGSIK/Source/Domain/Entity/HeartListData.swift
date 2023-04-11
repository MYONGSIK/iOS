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
