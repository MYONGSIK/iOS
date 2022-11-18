//
//  APIModel.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/19.
//

// MARK: 서버에서 공통적으로 오는 응답값을 Generic을 활용해 빼두었습니다.
struct APIModel<T: Decodable>: Decodable {
    let success: Bool?
    let httpCode: Int?
    let localDateTime: String?
    let httpStatus: String?
    let message: String?
    var data: T?
    
    let errorCode: String?
    let dayOfTheWeek: String?
}
