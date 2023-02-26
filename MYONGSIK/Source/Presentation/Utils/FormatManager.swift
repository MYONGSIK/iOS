//
//  FormatManage.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/19.
//

import Foundation

class FormatManager {
    // MARK: 서버에서 받은 시간을 Date로 변환합니다.
    // 서버에서의 시간과 Swift에서 다루는 Date의 형식이 다릅니다.
    // 서버에서 오는 시간: "2022-11-18T12:11:23.911Z"
    // Swift에서의 Date 객체: 2022-11-18 12:11:23
    func localDateTimeToDate(localDateTime: String) -> String {
        let startIndex = localDateTime.index(localDateTime.startIndex, offsetBy: 0)// 사용자지정 시작인덱스
        let endIndex = localDateTime.index(localDateTime.startIndex, offsetBy: 10)// 사용자지정 끝인덱스
        var sliced_date = localDateTime[startIndex ..< endIndex]
        
        if let dateStr = String(sliced_date).toDate()?.toString() {
            return dateStr
        } else {return ""}
    }
}
// MARK: - String extension
// String to Date
extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
// MARK: - Date extension
// Date to String
extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
}
