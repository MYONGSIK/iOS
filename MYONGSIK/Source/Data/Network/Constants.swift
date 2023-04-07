//
//  Constants.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/27.
//

// MARK: Network Constants
struct Location {
    var x: String
    var y: String
}
enum CampusInfo {
    case seoul
    case yongin
    
    var name: String {
        switch self {
            case .seoul: return "인문캠퍼스"
            case .yongin: return "자연캠퍼스"
        }
    }
    
    // MARK: 캠퍼스의 좌표 정보
    // 인캠 :: x(경도) - 126.9230255 & y(위도) - 37.5805970
    // 자캠 :: x(경도) - 127.1856568 & y(위도) - 37.2217101
    var x: String {
        switch self {
            case .seoul: return "&x=126.9230255"
            case .yongin: return "&x=127.1856568"
        }
    }
    
    var y: String {
        switch self {
            case .seoul: return "&y=37.5805970"
            case .yongin: return "&y=37.2217101"
        }
    }

    var keyword: String {
        switch self {
            case .seoul: return "서울 명지대 "
            case .yongin: return "용인 명지대 "
        }
    }
}

struct Constants {
    // API 연결 시
    static let BaseURL = "http://13.209.50.30"
    static let registerUser = "/api/v2/users"
    static let getDayFood = "/api/v2/meals"
    static let getWeekFood = "/api/v2/meals/week"
    static let postFoodEvaluate = "/api/v2/meals/evaluate"
    static let postFoodReview = "/api/v2/reviews"
    static let postFoodReviewWithArea = "/api/v2/reviews/area"
    static let getStoreRank = "/api/v2/scraps/store"
    static let postHeart = "/api/v2/scraps"
    
    // 카카오API: 키워드로 장소 검색
    static let KakaoURL = "https://dapi.kakao.com/v2/local/search/keyword.json?query="
    static let KakaoAuthorization = "KakaoAK " + "1167b82f504027f5cbddb0ba44492329"
    static let categoryCode = "&category_group_code=" + "FD6, CE7"
    static let seoulRadius = "&radius=" + "1500"
    static let yonginRadius = "&radius=" + "3000"
    static let page = "&page="
    static let size = "&size=20"
    static let sort = "&sort=distance" //거리순
}
