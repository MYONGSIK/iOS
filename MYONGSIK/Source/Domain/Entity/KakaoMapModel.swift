//
//  KakaoMapModel.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

// MARK: 카카오 검색 시 응답 모델
struct KakaoMapModel: Decodable {
    let documents: [KakaoResultModel]
}
struct KakaoResultModel: Decodable {
    let address_name: String?
    let category_group_code: String?
    let category_group_name: String?
    let category_name: String?
    let distance: String?
    let id: String?
    let phone: String?
    let place_name: String?
    let place_url: String?
    let road_address_name: String?
    let x: String?
    let y: String?
}
