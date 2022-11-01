//
//  SnackBar.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/02.
//

import Foundation
import UIKit

class SnackBar {
    // MARK: - Views
    let backgroundView = UIView().then{
        $0.backgroundColor = .signatureBlue
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
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
        
        // 만약 하단바가 존재할 때
        if (originView.tabBarController?.tabBar.isHidden == false) {
            originView.tabBarController?.tabBar.addSubview(backgroundView)
        } else {
            originView.view.addSubview(backgroundView)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(47)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-95)
            make.height.equalTo(47)
        }
        title.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        // MARK: Animation
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.backgroundView.transform = CGAffineTransform(translationX: 0, y: -120)
            } completion: { finished in
                UIView.animate(withDuration: 0.5, delay: 2.5) {
                    self.backgroundView.transform = .identity
                }
            }
        }
    }
}

// MARK: - Enum
extension SnackBar {
    enum SnackBarMessage: String {
        case addHeart = "찜꽁리스트에 추가되었습니다.💙"
        case deleteHeart = "찜꽁리스트에서 삭제되었습니다.🥲"
    }
}
