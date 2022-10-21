//
//  FormatManage.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/19.
//

import Foundation

class FormatManager {
    func localDateTimeToDate(localDateTime: String) -> String {
        let startIndex = localDateTime.index(localDateTime.startIndex, offsetBy: 0)// 사용자지정 시작인덱스
        let endIndex = localDateTime.index(localDateTime.startIndex, offsetBy: 10)// 사용자지정 끝인덱스
        var sliced_date = localDateTime[startIndex ..< endIndex]
        
        if let dateStr = String(sliced_date).toDate()?.toString() {
            return dateStr
        } else {return ""}
    }
}
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
extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
}
