//
//  UIFont.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/18.
//

import Foundation
import UIKit

// MARK: 폰트 정의
extension UIFont{
    // 자주 쓰이는 폰트를 enum으로 정리하였습니다.
    enum Family: String {
        case Bold, Regular, Light
    }
    
    static func NotoSansKR(size: CGFloat = 14, family: Family = .Regular) -> UIFont! {
        guard let font: UIFont = UIFont(name: "NotoSansKR-\(family)", size: size) else {
            return nil
        }
        return font
    }
}
