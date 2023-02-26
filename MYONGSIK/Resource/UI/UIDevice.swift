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
    // MARK: 노치 여부
    // 노치 유무에 따라 상단바와 하단바의 높이가 달라집니다.
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
    // MARK: 짧은 진동
    // 사용성과 직관성을 높이기 위하여, 버튼 클릭 시 짧은 진동을 줍니다.
    static func vibrate() {
        AudioServicesPlaySystemSound(1519)  // 짧은 진동
    }
}
