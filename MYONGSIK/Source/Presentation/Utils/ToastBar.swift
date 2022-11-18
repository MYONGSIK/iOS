//
//  SnackBar.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/02.
//

import Foundation
import UIKit

// MARK: 토스트바 직접 구현
// 찜꽁리스트 추가 시 띄워줍니다.
class ToastBar {
    // MARK: - Views
    let backgroundView = UIView().then{
        $0.backgroundColor = .signatureBlue
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
        $0.alpha = 0.3
        
        $0.layer.shadowColor = UIColor.black.cgColor // 색깔
        $0.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        $0.layer.shadowOffset = CGSize(width: 0, height: 0) // 위치조정
        $0.layer.shadowRadius = 4 // 반경
        $0.layer.shadowOpacity = 0.5 // alpha값
    }
    var title = UILabel().then{
        $0.textColor = .white
        $0.font = UIFont.NotoSansKR(size: 14, family: .Bold)
        $0.textAlignment = .center
        $0.numberOfLines = 1
    }
    // MARK: - Life Cycles
    var titleMessage: String!
    init(_ originView: UIViewController, message: SnackBarMessage) {
        title.text = message.rawValue
        backgroundView.addSubview(title)
        
        // 하단바가 존재할 때와 존재하지 않을 때를 나눠서 작업합니다.
        // 아마 카카오맛집url에서는 하단바가 존재하지 않을 것입니다.
        if (originView.tabBarController?.tabBar.isHidden == false) {
            originView.tabBarController?.tabBar.addSubview(backgroundView)
        } else {
            originView.view.addSubview(backgroundView)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-75)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-95)
            make.height.equalTo(47)
        }
        title.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        // MARK: Animation
        // 0.5초만에 생겨나고
        // 1.5초동안 유지
        // 0.5초만에 사라집니다.
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.backgroundView.alpha = 1
            } completion: { finished in
                UIView.animate(withDuration: 0.5, delay: 1.5) {
                    self.backgroundView.alpha = 0
                }
            }
        }
    }
}

// MARK: - Enum
// 토스트바에 쓸 문구를 정의합니다.
extension ToastBar {
    enum SnackBarMessage: String {
        case addHeart = "찜꽁리스트에 추가되었습니다.💙"
        case deleteHeart = "찜꽁리스트에서 삭제되었습니다.🥲"
    }
}
