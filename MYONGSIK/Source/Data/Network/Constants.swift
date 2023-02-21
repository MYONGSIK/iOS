//
//  Constants.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/27.
//

// MARK: Network Constants
struct Constants {
    // API 연결 시
    static let BaseURL = "http://54.180.152.115:8085"
    static let DevelopURL = "http://43.201.72.185:8085"
    static let getDayFood = "/api/v2/foods"
    static let getWeekFood = "/api/v2/foods/week"
    
    // 카카오API: 키워드로 장소 검색
    static let KakaoURL = "https://dapi.kakao.com/v2/local/search/keyword.json?query="
    static let KakaoAuthorization = "KakaoAK " + "1167b82f504027f5cbddb0ba44492329"
    static let keyword = "서울 명지대 "
    static let categoryCode = "&category_group_code=" + "FD6, CE7"
    static let x = "&x=" + "126.923460283882"
    static let y = "&y=" + "37.5803504797164"
    static let radius = "&radius=" + "1500"
    static let page = "&page="
    static let size = "&size=15"
    static let sort = "&sort=distance" //거리순
}
