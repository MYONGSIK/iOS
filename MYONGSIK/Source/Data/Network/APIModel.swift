//
//  APIModel.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/19.
//

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
