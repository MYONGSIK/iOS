//
//  CheckNotch.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/20.
//

import Foundation
import UIKit

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
