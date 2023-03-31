//
//  StoreModel.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/03/19.
//

import Foundation

// MARK: 찜꽁리스트 데이터 모델

struct StoreRankModel: Codable {
    let data: Data
    let httpCode: Int
    let httpStatus, localDateTime, message: String
    let success: Bool
}

// MARK: - DataClass
struct Data: Codable {
    let content: [StoreModel]
    let empty, first, last: Bool
    let number, numberOfElements: Int
    let pageable: Pageable
    let size: Int
    let sort: Sort
    let totalElements, totalPages: Int
}

// MARK: - Content
struct StoreModel: Codable {
    var address, category, code, contact: String?
    let distance, name: String?
    let scrapCount, storeId: Int?
    let urlAddress: String?
}

// MARK: - Pageable
struct Pageable: Codable {
    let offset, pageNumber, pageSize: Int
    let paged: Bool
    let sort: Sort
    let unpaged: Bool
}

// MARK: - Sort
struct Sort: Codable {
    let empty, sorted, unsorted: Bool
}


struct StoreParamModel: Decodable {
    let campus: String?
    let offset: Int?
    let paged: Bool?
    let pageNumber: Int?
    let pageSize: Int?
    let sort: String?
//    let sort.unsorted: Bool?
    let unpaged: Bool?
}
