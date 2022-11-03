//
//  TagTableViewCell.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit

class TagTableViewCell: UITableViewCell {

    // MARK: Life Cycles
    var tagCollectionView: UICollectionView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

//        setCollectionView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func setCollectionView(_ dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate) {
        tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()) .then{
            let flowLayout = UICollectionViewFlowLayout()
//            flowLayout.minimumLineSpacing = 10

            flowLayout.itemSize = CGSize(width: 108, height: 54)
            flowLayout.scrollDirection = .horizontal
            
            $0.collectionViewLayout = flowLayout
            $0.dataSource = dataSourceDelegate
            $0.delegate = dataSourceDelegate
            
            $0.showsHorizontalScrollIndicator = false
            $0.isPagingEnabled = true
            
            $0.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        }
        
        self.contentView.addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview()
            make.height.equalTo(54)
            make.leading.equalToSuperview().offset(16)
        }
    }
}
