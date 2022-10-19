//
//  UIFont.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/18.
//

import Foundation
import UIKit

extension UIFont{
    
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
