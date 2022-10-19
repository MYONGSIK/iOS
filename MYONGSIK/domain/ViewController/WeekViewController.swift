//
//  WeekViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/19.
//

import UIKit

class WeekViewController: BaseViewController {
    // MARK: - Views
    private let pageControl = UIPageControl().then{
        $0.hidesForSinglePage = true
        $0.numberOfPages = 5
        $0.currentPageIndicatorTintColor = .signatureBlue
        $0.pageIndicatorTintColor = .lightGray
    }
    // MARK: - Life Cycles
    var weekCollectionView: UICollectionView!
    var weekFoodData: [WeekFoodModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.titleLabel.text = "주간 식단표"

        setCollectionView(self)
        setUpView()
        setUpConstraint()
        
        DayFoodDataManager().getWeekFoodDataManager(self)
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
    }
    func setUpView() {
        self.view.addSubview(weekCollectionView)
        self.view.addSubview(pageControl)
    }
    func setUpConstraint() {
        weekCollectionView.snp.makeConstraints { make in
            make.top.equalTo(super.titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(500)
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalTo(weekCollectionView)
            make.top.equalTo(weekCollectionView.snp.bottom)
        }
    }
}
// MARK: - CollectionView delegate
extension WeekViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let count = weekFoodData.count ?? 0
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCollectionViewCell.identifier,
                                                            for: indexPath)
                as? WeekCollectionViewCell else{ fatalError() }
        let itemIdx = indexPath.item
        if let weekFoodData = self.weekFoodData {
            cell.setUpData(weekFoodData[itemIdx])
        }
        
        return cell
    }
    // collectionview indicator
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / scrollView.frame.width)
        self.pageControl.currentPage = page
    }
}
// MARK: - API Success
extension WeekViewController {
    func getWeekFoodAPISuccess(_ result: [WeekFoodModel]) {
        self.weekFoodData = result
        self.weekCollectionView.reloadData()
    }
}
