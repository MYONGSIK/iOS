//
//  TagCollectionViewCell.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit

// MARK: 명지맛집 페이지 > '#모아뒀으니 골라보세요!' 아래의 #태그가 붙여져있는 셀
class TagCollectionViewCell: UICollectionViewCell {
    static let identifier = "TagCollectionViewCell"
    
    // MARK: - Views
    let backView = UIView().then{
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 18
        
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.masksToBounds = false
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.layer.shadowRadius = 4
        $0.layer.shadowOpacity = 0.2
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
