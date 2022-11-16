//
//  CheckNotch.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/20.
//

import Foundation
import UIKit
import AVFoundation

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
    static func vibrate() {
        AudioServicesPlaySystemSound(1519)  // 짧은 진동
    }
}
