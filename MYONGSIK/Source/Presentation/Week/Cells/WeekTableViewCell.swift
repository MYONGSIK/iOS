//
//  WeekTableViewCell.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/20.
//

import UIKit

class WeekTableViewCell: UITableViewCell {
    let titleLabel = UILabel().then{
        $0.text = "주간 식단표"
        $0.font = UIFont.NotoSansKR(size: 18, family: .Bold)
    }
    //MARK: - LifeCycle
    var weekCollectionView: UICollectionView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            if UIDevice.current.hasNotch {make.top.equalToSuperview().offset(38)}
            else {make.top.equalToSuperview().offset(18)}
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setCollectionView(_ dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate) {
        weekCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()) .then{
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0

            var bounds = UIScreen.main.bounds
            var width = bounds.size.width
            
            flowLayout.itemSize = CGSize(width: width, height: 500)
            flowLayout.scrollDirection = .horizontal
            
            $0.collectionViewLayout = flowLayout
            $0.dataSource = dataSourceDelegate
            $0.delegate = dataSourceDelegate
            
            $0.showsHorizontalScrollIndicator = false
            $0.isPagingEnabled = true
            
            $0.register(WeekCollectionViewCell.self, forCellWithReuseIdentifier: WeekCollectionViewCell.identifier)
        }
        
        self.contentView.addSubview(weekCollectionView)
        weekCollectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
        }
    }
    
}
