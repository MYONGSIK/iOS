//
//  MainFoodTableViewCell.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/05/11.
//

import UIKit

// MARK: 스와이프가 가능하도록 CollectionView를 포함한 TableView Cell
class MainFoodTableViewCell: UITableViewCell {

    var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCollectionView(_ dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()) .then{
            let flowLayout = UICollectionViewFlowLayout()
//            flowLayout.minimumLineSpacing = 10
            flowLayout.itemSize = CGSize(width: 108, height: 54)
            flowLayout.scrollDirection = .horizontal

            $0.collectionViewLayout = flowLayout
            $0.dataSource = dataSourceDelegate
            $0.delegate = dataSourceDelegate

            $0.showsHorizontalScrollIndicator = false
            $0.isPagingEnabled = true

//            $0.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
            $0.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        }
        
        self.contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
            make.height.equalTo(200)
        }
        
    }
}
