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

struct HeartModel {
    let address: String?
    let campus: String?
    let category: String?
    let code: String?
    let contact: String?
    let distance: String?
    let name: String?
    let phoneId: String?
    let urlAddress: String?
}


//{
//  "address": {},
//  "campus": {},
//  "category": {},
//  "code": {},
//  "contact": {},
//  "distance": {},
//  "name": {},
//  "phoneId": {},
//  "urlAddress": {}
//}
