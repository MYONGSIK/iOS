//
//  ViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/18.
//

import UIKit
import SnapKit
import Then

class MainViewController: BaseViewController {
    // MARK: - Views
    let leftIcon = UIButton().then{
        $0.setImage(UIImage(named: "calendar"), for: .normal)
    }
    let checkWeekButton = UIButton().then{
        var config = UIButton.Configuration.tinted()
        var attText = AttributedString.init("이번 주  식단 확인하기")
        
        attText.font = UIFont.NotoSansKR(size: 14, family: .Regular)
        attText.foregroundColor = UIColor.black
        config.attributedTitle = attText
        config.background.backgroundColor = .white
        config.cornerStyle = .capsule
        
        $0.configuration = config
        $0.clipsToBounds = true
        
        $0.layer.shadowColor = UIColor.black.cgColor // 색깔
        $0.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        $0.layer.shadowOffset = CGSize(width: 0, height: 0) // 위치조정
        $0.layer.shadowRadius = 2 // 반경
        $0.layer.shadowOpacity = 0.25 // alpha값
    }

    // MARK: - Life Cycles
    var mainTableView: UITableView!
    var foodData: [DayFoodModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.titleLabel.text = "오늘의 식단"
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        DayFoodDataManager().getDayFoodDataManager(self)
        
        setUpTableView(dataSourceDelegate: self)
        setUpView()
        setUpConstraint()
        
        self.leftIcon.addTarget(self, action: #selector(calenderButtonDidTap), for: .touchUpInside)
        self.checkWeekButton.addTarget(self, action: #selector(calenderButtonDidTap), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc func calenderButtonDidTap() {
        let vc = WeekViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Functions
    func setUpTableView(dataSourceDelegate: UITableViewDelegate & UITableViewDataSource) {
        mainTableView = UITableView()
        mainTableView.then{
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
            
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.separatorStyle = .none
        }
    }
    func setUpView() {
        super.navigationView.addSubview(leftIcon)
        
        self.view.addSubview(mainTableView)
        self.view.addSubview(checkWeekButton)
    }
    func setUpConstraint() {
        leftIcon.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.leading.equalToSuperview().offset(22)
            make.centerY.equalTo(super.logoImage)
        }
        checkWeekButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(69)
            make.height.equalTo(50)
            if CheckNotch().hasNotch() {make.bottom.equalToSuperview().offset(-57)}
            else {make.bottom.equalToSuperview().offset(-27)}
            make.centerX.equalToSuperview()
        }
        mainTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(super.titleLabel.snp.bottom).offset(2)
            make.bottom.equalTo(checkWeekButton.snp.top).offset(-10)
        }
    }
}

// MARK: - TableView delegate
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = self.foodData {
            return data.count
        } else {return 0}
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        let itemIdx = indexPath.item
        if let foodData = self.foodData {
            cell.data = foodData[itemIdx]
            cell.setUpData()
            cell.setUpButtons()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: - API Success
extension MainViewController {
    //일간 조회
    func getDayFoodAPISuccess(_ result: [DayFoodModel]) {
//        print(result)
        self.foodData = result
        hideEmptyView()
        mainTableView.reloadData()
    }
    // 405 error : 공휴일 X
    func noFoodAPI(_ result: APIModel<[DayFoodModel]>) {
        showEmptyView(result)
        mainTableView.reloadData()
//        print(result)
//        setTempData()
    }
    
    // Tableview
    func showEmptyView(_ result: APIModel<[DayFoodModel]>) {
        let backView = UIView().then{
            $0.backgroundColor = .white
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
            $0.layer.borderColor = UIColor.borderColor.cgColor
            $0.layer.borderWidth = 1
        }
        let date = UILabel().then{
            if let localDateTime = result.localDateTime {
                $0.text = FormatManager().localDateTimeToDate(localDateTime: localDateTime)
            }
            $0.font = UIFont.NotoSansKR()
            $0.textColor = .signatureBlue
        }
        let dayOfTheWeek = UILabel().then{
            if let dayOfWeek = result.dayOfTheWeek {$0.text = dayOfWeek}
            $0.font = UIFont.NotoSansKR()
            $0.textColor = .signatureBlue
        }
        var messageLabel = UILabel().then{
            if let message = result.message {$0.text = message}
            $0.font = UIFont.NotoSansKR(size: 16, family: .Regular)
            $0.numberOfLines = 0
        }
        let backgroudView = UIView(frame: CGRect(x: 0, y: 0, width: mainTableView.bounds.width, height: mainTableView.bounds.height))
        backgroudView.addSubview(backView)
        backView.addSubview(date)
        backView.addSubview(dayOfTheWeek)
        backView.addSubview(messageLabel)
        
        backView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(178)
        }
        date.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(23)
            make.top.equalToSuperview().offset(19)
        }
        dayOfTheWeek.snp.makeConstraints { make in
            make.centerY.equalTo(date)
            make.leading.equalTo(date.snp.trailing).offset(3)
        }
        messageLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        mainTableView.backgroundView = backgroudView
    }
    func hideEmptyView() {
        mainTableView.backgroundView?.isHidden = true
    }
//    func setTempData() {
//        self.foodData = []
//        self.foodData.append(DayFoodModel(toDay: "2022-10-19", dayOfTheWeek: "수요일", classification: "중식", type: "A", status: "운영", food1: "food1", food2: "food1", food3: "food1", food4: "food1", food5: "food1", food6: "food1"))
//        self.foodData.append(DayFoodModel(toDay: "2022-10-19", dayOfTheWeek: "수요일", classification: "중식", type: "A", status: "운영", food1: "food1", food2: "food1", food3: "food1", food4: "food1", food5: "food1", food6: "food1"))
//        self.foodData.append(DayFoodModel(toDay: "2022-10-19", dayOfTheWeek: "수요일", classification: "중식", type: "A", status: "운영", food1: "food1", food2: "food1", food3: "food1", food4: "food1", food5: "food1", food6: "food1"))
//        mainTableView.reloadData()
//    }
}
