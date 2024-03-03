//
//  PageCell.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/08/26.
//

import UIKit

class PageCell: UICollectionViewCell {
    private let foodInfoTableView = UITableView()
    
    private var day = 0
    var foodList: [DayFoodModel] = []
    var area: Area?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        foodInfoTableView.dataSource = self
        foodInfoTableView.delegate = self
        foodInfoTableView.isScrollEnabled = false
        
        foodInfoTableView.rowHeight = UITableView.automaticDimension
        foodInfoTableView.estimatedRowHeight = UITableView.automaticDimension
        
        foodInfoTableView.separatorStyle = .none
        foodInfoTableView.register(FoodInfoCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setupView() {
        self.contentView.addSubview(foodInfoTableView)
    }
    
    private func setupConstraints() {
        foodInfoTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func setDay(page: Int) {
        day = page
        foodInfoTableView.reloadData()
    }
    
}

extension PageCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FoodInfoCell
        cell.setContent(foodInfo: foodList[indexPath.row], area: area!)
        return cell
    }
    
    
}
