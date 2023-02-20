//
//  String+.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/02/20.
//

import Foundation

extension String {
    func attributed(of searchString: String, value: [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
    
        let attributedString = NSMutableAttributedString(string: self)
        let length = self.count
        
        var range = NSRange(location: 0, length: length)
        var rangeArray = [NSRange]()

        while range.location != NSNotFound {
            range = (attributedString.string as NSString).range(of: searchString, options: .caseInsensitive, range: range)
            rangeArray.append(range)

            if range.location != NSNotFound {
                range = NSRange(location: range.location + range.length, length: self.count - (range.location + range.length))
            }
        }
        
        rangeArray.forEach { range in
            value.forEach { values in
                attributedString.addAttribute(values.key, value: values.value, range: range)
            }
        }

        return attributedString
    }
}
