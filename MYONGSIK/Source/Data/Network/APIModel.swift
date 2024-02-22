//
//  APIModel.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/19.
//

// MARK: 서버에서 공통적으로 오는 응답값을 Generic을 활용해 빼두었습니다.
struct APIModel<T: Decodable>: Decodable {
    let success: Bool
    let httpCode: Int?
    let localDateTime: String?
    let httpStatus: String?
    let message: String?
    var data: T?
}


struct ListModel<T: Codable>: Codable {
    let content: [T]?
    let empty, first, last: Bool
    let number, numberOfElements: Int
    let pageable: Pageable
    let size: Int
    let sort: Sort
    let totalElements, totalPages: Int
}

struct Pageable: Codable {
    let offset, pageNumber, pageSize: Int
    let paged: Bool
    let sort: Sort
    let unpaged: Bool
}

struct Sort: Codable {
    let empty, sorted, unsorted: Bool
}
