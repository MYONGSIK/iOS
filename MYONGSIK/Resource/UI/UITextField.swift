//
//  UITextField.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import Foundation
import UIKit

extension UITextField {
    // MARK: Add padding
    func addPadding(left: CGFloat = 6, right: CGFloat = 6) {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.height))
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.height))
        self.leftView = leftPaddingView
        self.rightView = rightPaddingView
        self.leftViewMode = ViewMode.always
        self.rightViewMode = ViewMode.always
    }
    // MARK: Clear button Custom
    func setClearButton(with image: UIImage, mode: UITextField.ViewMode) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        clearButton.contentMode = .scaleAspectFit
        self.rightView = clearButton
        self.rightViewMode = mode
    }
}
