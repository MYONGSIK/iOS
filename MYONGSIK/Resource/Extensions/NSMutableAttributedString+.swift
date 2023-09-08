//
//  NSMutableAttributedString+.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/08/26.
//

import Foundation

extension NSMutableAttributedString {

    func blueBold(string: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let font = UIFont.NotoSansKR(size: fontSize, family: .Bold)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor.signatureBlue]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }

    func grayRegular(string: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let font = UIFont.NotoSansKR(size: fontSize, family: .Regular)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor.signatureGray]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
}
