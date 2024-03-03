//
//  StoreModel.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/03/19.
//

import Foundation

// MARK: 찜꽁리스트 데이터 모델

struct RestaurantModel: Codable {
    var address, category, code, contact: String?
    let distance, name: String?
    let scrapCount, storeId: Int?
    let urlAddress: String?
    var longitude, latitude: String?
}

struct StoreParamModel: Decodable {
    let campus: String?
    let offset: Int?
    let paged: Bool?
    let pageNumber: Int?
    let pageSize: Int?
    let sort: String?
    let unpaged: Bool?
}
