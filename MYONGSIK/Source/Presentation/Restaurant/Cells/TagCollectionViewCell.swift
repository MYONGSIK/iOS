//
//  TagCollectionViewCell.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    static let identifier = "TagCollectionViewCell"
    
    // MARK: - Views
    let backView = UIView().then{
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 18
        
        $0.layer.shadowColor = UIColor.black.cgColor // 색깔
        $0.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        $0.layer.shadowOffset = CGSize(width: 0, height: 0) // 위치조정
        $0.layer.shadowRadius = 4 // 반경
        $0.layer.shadowOpacity = 0.2 // alpha값
    }
    let titleLabel = UILabel().then{
        $0.text = "#Tag"
        $0.font = UIFont.NotoSansKR(size: 18, family: .Regular)
    }
    
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.contentView.addSubview(backView)
        backView.addSubview(titleLabel)
        
        backView.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.leading.trailing.equalToSuperview().inset(5)
            make.centerY.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
