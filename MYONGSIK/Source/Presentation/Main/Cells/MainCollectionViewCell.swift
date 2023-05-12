//
//  MainCollectionViewCell.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/05/11.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    static let identifier = "MainCollectionViewCell"

    var isToday: Bool = true
    var isWeekend: Bool = false
    var isFoodDataIsEmpty: Bool = false

    var selectedResName: String? = ""
    
    var foodData: [DayFoodModel]? = []
    
    var tableView: UITableView!
    var containerView = UIView().then { $0.backgroundColor = .white }
    
    func setupTableView() {
        print("setupTableView")
        tableView = UITableView()
        tableView.then{
            $0.delegate = self
            $0.dataSource = self
            $0.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
            $0.isScrollEnabled = false

            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.separatorStyle = .none
            $0.allowsSelection = false
        }
    }
    
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.setupTableView()
        
        self.contentView.addSubview(containerView)
        containerView.addSubview(tableView)
        
        containerView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview().inset(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = self.foodData { return data.count }
        else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        if let res = self.selectedResName {
            cell.selectedRestaurant = res
            
        } else { print("selectedResName이 설정되지 않음") }
        
        let itemIdx = indexPath.row
        
        if self.foodData!.count > 0 {
            cell.data = self.foodData![itemIdx]
            cell.isWeekend = self.isWeekend
            cell.setUpData()
            cell.setUpButtons()
            cell.checkIsToday(isToday: self.isToday)

        }
        return cell
    }
}
