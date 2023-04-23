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
    
    let resInfo = [
        [YonginRestaurant.staff.rawValue, "중식 11:30~13:30  |  석식 17:30~18:30"],
        [YonginRestaurant.dormitory.rawValue, "중식 11:30~13:30  |  석식 17:00~18:30"],
        [YonginRestaurant.academy.rawValue, "조식 08:30~09:30  |  중식 10:00~15:00"],
        [YonginRestaurant.myungjin.rawValue, "백반 11:30~14:30 \n샐러드,볶음밥 10:00~15:00"]
    ]
    
//    let adImageView = UIView().then{
//        $0.backgroundColor = .systemGray4
//        $0.layer.cornerRadius = 15
//    }
    
    var buttonTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView(delegate: self)
        setup()
        
        showUpdateAlert()
    }
    
    private func showUpdateAlert() {
        if UserDefaults.standard.value(forKey: "StopAlert") == nil {
            let updateAlert = UpdateBottomAlertViewController()
            
            updateAlert.modalPresentationStyle = .overFullScreen
            
            self.present(updateAlert, animated: true)
        }
    }
    
    func setUpTableView(delegate: UITableViewDelegate & UITableViewDataSource) {
        buttonTableView = UITableView().then{
            $0.delegate = delegate
            $0.dataSource = delegate
            
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.separatorStyle = .none
        }
    }
    
    func setup() {
//        self.view.addSubview(adImageView)
        self.view.addSubview(buttonTableView)
        
//        adImageView.snp.makeConstraints {
//            $0.top.equalTo(super.navigationImgView.snp.bottom).inset(10)
//            $0.leading.equalToSuperview().offset(15)
//            $0.trailing.equalToSuperview().inset(15)
//            $0.height.equalTo(70)
//        }
        buttonTableView.snp.makeConstraints {
//            $0.top.equalTo(adImageView.snp.bottom).offset(5)
            $0.top.equalTo(super.navigationImgView.snp.bottom).inset(10)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview()
        }
    }
}

extension SelectRestaurantViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        setButtonCell(cell, info: resInfo[indexPath.row])
        print("setting cell")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        // TODO: 선택된 식당의 학식 정보를 토대로 화면으로 전환 (MainVC) / 현재 화면 전환만 구현해둠
        let mainVC = MainViewController()
        mainVC.selectedResName = resInfo[indexPath.row][0]
        if mainVC.selectedResName == YonginRestaurant.myungjin.rawValue {
            mainVC.operatingTimeText = "백반 11:30~14:30 | 샐러드,볶음밥 10:00~15:00"
        } else {
            mainVC.operatingTimeText = resInfo[indexPath.row][1]
        }
        
        
        
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
}

extension SelectRestaurantViewController {
    private func setButtonCell(_ cell: UITableViewCell, info: [String]) {

        let containerView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 15
            $0.layer.borderWidth = 0.1
            
            $0.layer.shadowColor = UIColor.gray.cgColor
            $0.layer.masksToBounds = false
            $0.layer.shadowOffset = CGSize(width: 0, height: 0)
            $0.layer.shadowRadius = 4
            $0.layer.shadowOpacity = 0.25
        }
        let restaurantNameLabel = UILabel().then {
            $0.text = info[0]
            $0.font = UIFont.NotoSansKR(size: 24, family: .Bold)
            $0.textColor = .signatureBlue
        }
        let operatingTimeLabel = UILabel().then {
            $0.font = UIFont.NotoSansKR(size: 16, family: .Regular)
            $0.text = "운영시간 \n\(info[1])"
            $0.textColor = .black
            $0.numberOfLines = 0
        }
        let intoButton = UIButton().then {
            $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            $0.tintColor = .signatureBlue
        }
        
        cell.contentView.addSubview(containerView)
        containerView.addSubview(restaurantNameLabel)
        containerView.addSubview(operatingTimeLabel)
        containerView.addSubview(intoButton)
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.bottom.leading.trailing.equalToSuperview().inset(5)
        }
        restaurantNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(50)
            $0.leading.equalToSuperview().offset(20)
        }
        operatingTimeLabel.snp.makeConstraints {
            $0.leading.equalTo(restaurantNameLabel.snp.leading)
            $0.top.equalTo(restaurantNameLabel.snp.bottom)
            $0.bottom.equalToSuperview().inset(50)
        }
        intoButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
        }
        
    }
}
