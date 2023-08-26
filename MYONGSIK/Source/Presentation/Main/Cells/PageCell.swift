//
//  PageCell.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/08/26.
//

import UIKit
import SnapKit

class PageCell: UICollectionViewCell {
    private let foodInfoTableView = UITableView()
    
    private var day = 0
    
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
    }
    
}

extension PageCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FoodInfoCell
        
        MainViewModel.shared.getDayFood(day: day, index: indexPath.row, cancelLabels: &cell.cancelLabels) { foodInfo in
            print(foodInfo)
            cell.setContent(foodInfo: foodInfo)
        }
        
        return cell
    }
    
    
}
