//
//  RestaurantTagViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit
import Toast
import Combine
import CombineCocoa

// MARK: 명지맛집 > 태그CollectionView셀 클릭 후 나오는 페이지입니다.
class RestaurantTagViewController: BaseViewController {
    var tag = ""
    var tagResult: [RestaurantModel] = []
    var pageNum: Int = 1
    
    
    let backButton = UIButton().then{
        $0.setImage(UIImage(named: "arrow_left_gray"), for: .normal)
    }
    let subTitleLabel = UILabel().then{
        $0.font = UIFont.NotoSansKR(size: 24, family: .Bold)
        $0.textColor = .black
    }

    var tagResultTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        
        setUpTableView(dataSourceDelegate: self)
        setUpView()
        setUpConstraint()
        
        self.backButton.addTarget(self, action: #selector(goBackButtonDidTap), for: .touchUpInside)
    }

    // MARK: Actions
    @objc func goBackButtonDidTap() {
        UIDevice.vibrate()
        self.navigationController?.popViewController(animated: true)
    }

    func setUpTableView(dataSourceDelegate: UITableViewDelegate & UITableViewDataSource) {
        tagResultTableView = UITableView()
        tagResultTableView.then{
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
            
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
        }
    }
    func setUpView() {
        self.subTitleLabel.text = "# 명지\(tag)"
        
        super.navigationView.addSubview(backButton)
        super.navigationView.addSubview(subTitleLabel)
        
        self.view.addSubview(tagResultTableView)
    }
    func setUpConstraint() {
        backButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-23)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing).offset(10)
            make.centerY.equalTo(backButton)
        }
        tagResultTableView.snp.makeConstraints { make in
            make.top.equalTo(super.navigationView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    
    func reloadDataAnimation() {
        // reload data with animation
        UIView.transition(with: self.tagResultTableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
                          self.tagResultTableView.reloadData()},
                          completion: nil);
    }
}
// MARK: - TableView delegate
extension RestaurantTagViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.tagResult.count
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        let itemIdx = indexPath.item
        cell.setupRestaurant(self.tagResult[itemIdx], .kakaoCell)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
