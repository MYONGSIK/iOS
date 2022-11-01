//
//  Constants.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/27.
//

// MARK: Network Constants
struct Constants {
    static let BaseURL = "http://54.180.152.115:8085"
    static let getDayFood = "/api/v1/foods"
    static let getWeekFood = "/api/v1/foods/week"
    
    static let KakaoURL = "https://dapi.kakao.com/v2/local/search/keyword.json?query="
    static let KakaoAuthorization = "KakaoAK " + "1167b82f504027f5cbddb0ba44492329"
}
