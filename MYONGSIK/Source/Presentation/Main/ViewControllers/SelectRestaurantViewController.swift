//
//  SelectRestaurantViewController.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/02/21.
//

import UIKit
import SnapKit



// MARK: 자연캠 식당 선택 화면
class SelectRestaurantViewController: MainBaseViewController {
    
    private var buttonTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupView()
        setupConstraints()
        setupObserver()
    }
    
    private func setup() {
        super.setCampusButton.isHidden = false
        
        buttonTableView.delegate = self
        buttonTableView.dataSource = self
        
        buttonTableView.register(RestaurantSelectCell.self, forCellReuseIdentifier: "cell")
        
        buttonTableView.rowHeight = UITableView.automaticDimension
        buttonTableView.estimatedRowHeight = UITableView.automaticDimension
        buttonTableView.separatorStyle = .none
    
    }
    
    private func setupView() {
        self.view.addSubview(buttonTableView)
    }
    
    private func setupConstraints() {
        buttonTableView.snp.makeConstraints {
            $0.top.equalTo(super.navigationImgView.snp.bottom).inset(10)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupObserver() {
        MainViewModel.shared.isFood { result in
            if result {
                let mainVC = MainViewController()
                self.navigationController?.pushViewController(mainVC, animated: true)
            }
        }
    }
}

extension SelectRestaurantViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MainViewModel.shared.getRestaurantsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RestaurantSelectCell
        
        cell.setupContent(restaurant: MainViewModel.shared.getRestaurant(index: indexPath.row))
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: 선택된 식당의 학식 정보를 토대로 화면으로 전환 (MainVC) / 현재 화면 전환만 구현해둠
        MainViewModel.shared.getWeekFood(area: MainViewModel.shared.getRestaurant(index: indexPath.row).getServerName())
    }
}
