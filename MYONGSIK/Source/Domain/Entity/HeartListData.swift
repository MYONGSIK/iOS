//
//  HeartListModel.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/02.
//

import Foundation
import RealmSwift


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
