//
//  WeekViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/19.
//

import UIKit
import RxSwift
import RxCocoa

class WeekViewController: MainBaseViewController {
    // MARK: - Views
    let goBackButton = UIButton().then{
        $0.setImage(UIImage(named: "arrow_left"), for: .normal)
    }
    let pageControl = UIPageControl().then{
        $0.hidesForSinglePage = true
        $0.numberOfPages = 5
        $0.currentPageIndicatorTintColor = .signatureBlue
        $0.pageIndicatorTintColor = .lightGray
    }
    // MARK: - Life Cycles
    var weekTableView: UITableView!
    var weekFoodData: [WeekFoodModel]!
    let disposeBag = DisposeBag()
    private let viewModel = WeekViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        setUpTableView()
        setUpView()
        setUpConstraint()
        bind()
        
        goBackButton.rx.tap
            .bind {self.goBackButtonDidTap()}
            .disposed(by: disposeBag)
    }
    private func bind() {
        let output = viewModel.transform(input: WeekViewModel.Input())
        
        output.foodDataSubject.bind(onNext: { [weak self] result in
            self?.getWeekFoodAPISuccess(result.data ?? [])
        }).disposed(by: disposeBag)
    }
    // MARK: - Actions
    @objc func goBackButtonDidTap() {
        UIDevice.vibrate()
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Functions
    func setUpTableView() {
        weekTableView = UITableView().then{
            $0.delegate = self
            $0.dataSource = self
            $0.register(WeekTableViewCell.self, forCellReuseIdentifier: "WeekTableViewCell")
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
        }
    }
    func setUpView() {
        super.navigationView.addSubview(goBackButton)
        
        self.view.addSubview(weekTableView)
        self.view.addSubview(pageControl)
    }
    func setUpConstraint() {
        goBackButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerY.equalTo(super.logoImage)
            make.leading.equalToSuperview().offset(18)
        }
        weekTableView.snp.makeConstraints { make in
            make.top.equalTo(super.navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(570)
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalTo(weekTableView)
            if UIDevice.current.hasNotch {make.top.equalTo(weekTableView.snp.bottom)}
            else {make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-5)}
        }
    }
}
// MARK: - TableView delegate
extension WeekViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeekTableViewCell", for: indexPath) as? WeekTableViewCell else { return UITableViewCell() }
        cell.setCollectionView(self)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        self.weekTableView.reloadData()
    }
}
