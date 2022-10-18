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
        $0.numberOfPages = 7
        $0.currentPageIndicatorTintColor = .signatureBlue
        $0.pageIndicatorTintColor = .lightGray
    }
    // MARK: - Life Cycles
    var weekCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.titleLabel.text = "주간 식단표"

        setCollectionView(self)
        setUpView()
        setUpConstraint()
    }
    // MARK: - Functions
    func setCollectionView(_ dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate) {
        weekCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()) .then{
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
            

            var bounds = UIScreen.main.bounds
            var width = bounds.size.width
            
            flowLayout.itemSize = CGSize(width: width, height: 450)
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
            make.height.greaterThanOrEqualTo(450)
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
//        let count = folderData.count ?? 0
//        EmptyView().setEmptyView(self.emptyMessage, self.folderView.folderCollectionView, count)
        return 7
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCollectionViewCell.identifier,
                                                            for: indexPath)
                as? WeekCollectionViewCell else{ fatalError() }
//        let itemIdx = indexPath.item
//        cell.setUpData(self.folderData[itemIdx])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let itemIdx = indexPath.item
//        let folderName = self.folderData[itemIdx].folder_name
//        let folderId = self.folderData[itemIdx].folder_id
//
//        let vc = FolderDetailViewController()
//        vc.folderName = folderName
//        vc.folderId = folderId
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    // collectionview indicator
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / scrollView.frame.width)
        self.pageControl.currentPage = page
    }
}
