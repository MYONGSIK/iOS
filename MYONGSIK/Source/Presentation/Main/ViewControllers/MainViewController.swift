//
//  ViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/18.
//

import UIKit
import SnapKit
import Then

// MARK: '오늘의 학식' 페이지
class MainViewController: MainBaseViewController {
    var isToday: Bool = true
    var selectedResName: String?
    var isFoodDataIsEmpty: Bool = false
    
    
    // MARK: - Views
    let scrolleView = UIScrollView()
    let contentView = UIView()
    
    let adImageView = UIView().then{
        $0.backgroundColor = .systemGray4
        $0.layer.cornerRadius = 15
    }
    
    var tableView: UITableView!
    
    let titleView = UIView().then {
        $0.backgroundColor = .clear
    }

    lazy var titleLabel = UILabel().then{
        $0.text = "오늘의 학식  |  \(getTodayDataText(date: Date()))"
        $0.font = UIFont.NotoSansKR(size: 22, family: .Bold)
        $0.textColor = UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1)
    }

    let operatingTimeLabel = UILabel().then{
        $0.font = UIFont.NotoSansKR(size: 12, family: .Regular)
        $0.textColor = .gray

        $0.attributedText = "운영시간  |  중식 11:30~17:30  |  석식 18:00~21:00"
            .attributed(of: "운영시간", value: [
                .foregroundColor: UIColor.darkGray
            ])
    }
    
    let changeDayButtonView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .horizontal
        $0.distribution = .fillEqually 
    }
    
    let goBeforeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.tintColor = .signatureBlue
        $0.addTarget(self, action: #selector(didTapGoBeforeButton(_:)), for: .touchUpInside)
    }
    
    let goAfterButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.tintColor = .signatureBlue
        $0.addTarget(self, action: #selector(didTapGoAfterButton(_:)), for: .touchUpInside)
    }
    
    private func setArrowButtons(currentPageControl: Int) {
        goBeforeButton.isEnabled = true; goBeforeButton.tintColor = .signatureBlue
        goAfterButton.isEnabled = true; goAfterButton.tintColor = .signatureBlue
        switch currentPageControl {
        case 0:
            goBeforeButton.isEnabled = false; goBeforeButton.tintColor = .lightGray
        case 4:
            goAfterButton.isEnabled = false; goAfterButton.tintColor = .lightGray
        default:
            return
        }
    }
    
    @objc private func didTapGoBeforeButton(_ sender: UIButton) { didTapChangeDateButton(value: -1) }
    @objc private func didTapGoAfterButton(_ sender: UIButton) { didTapChangeDateButton(value: 1) }
    
    private func didTapChangeDateButton(value: Int) {
        tablePageControl.currentPage += value
        setArrowButtons(currentPageControl: tablePageControl.currentPage)
        
        // set titleLabel
        let date = Calendar.current.date(byAdding: .day, value: tablePageControl.currentPage, to: startDay!)
        titleLabel.text  = "오늘의 학식  |  \(getTodayDataText(date: date!))"
        
        // set daily food data
        let today = Calendar.current.date(byAdding: .day, value: 4, to: startDay!)
        if date == today { isToday = true }
        else { isToday = false }
        
        self.foodData = getDailyFoodData(date: date!)
        if foodData?.count == 0 {
            tablePageControl.isHidden = true
            submitButton.isHidden = true
        } else {
            tablePageControl.isHidden = false
            submitButton.isHidden = false
        }
        tableView.reloadData()
        tableView.snp.updateConstraints{
            $0.height.equalTo(foodData!.count * 170 + 50)
        }
    }
    
    
    let tablePageControl = UIPageControl().then {
        $0.numberOfPages = 5
        $0.pageIndicatorTintColor = .lightGray
        $0.currentPageIndicatorTintColor = .signatureBlue
        $0.addTarget(self, action: #selector(pageChanged(_:)), for: .valueChanged)
    }
    
    let submitButton = UIButton().then{
        var config = UIButton.Configuration.tinted()
        var attText = AttributedString.init("학식에 대한 의견 남기기")
        
        attText.font = UIFont.NotoSansKR(size: 14, family: .Bold)
        attText.foregroundColor = UIColor.white
        config.attributedTitle = attText
        config.background.backgroundColor = .signatureBlue
        config.cornerStyle = .capsule
        
        $0.configuration = config
        $0.clipsToBounds = true
        $0.setImage(UIImage(named: "pencil"), for: .normal)
        
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.masksToBounds = false
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.layer.shadowRadius = 2
        $0.layer.shadowOpacity = 0.25
        
        $0.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    @objc private func pageChanged(_ sender: UIPageControl) { print("pageChanged") }
    
    // MARK: - Life Cycles
    var startDay: Date?
    var endDay: Date?
    
    var mainTableView: UITableView!
    var foodData: [DayFoodModel]? = []
    var weekFoodData: [DayFoodModel]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSelectedRes()
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        setUpTableView(dataSourceDelegate: self)
        setUpView()
        setUpConstraint()
        
        setWeekDateData()
        fetchWeekData()
        fetchDailyData()
        
        tableView.snp.updateConstraints{ $0.height.equalTo(foodData!.count * 170 + 50) }
    }
    
    private func setSelectedRes() {
        if let userCampus = UserDefaults.standard.value(forKey: "userCampus") {
            switch userCampus as! String {
            case Campus.seoul.rawValue:
                selectedResName = SeoulRestaurant.mcc.rawValue
                print("인문캠 선택 - 식당 :: \(selectedResName!)")
            case Campus.yongin.rawValue:
                print("자연캠 선택 - 식당 :: \(selectedResName)")
            default:
                return
            }
        }
    }
    
    private func fetchDailyData() {
        print(Constants.getDayFood + "/\(selectedResName!)")
        APIManager.shared.getData(urlEndpointString: Constants.getDayFood + "/\(selectedResName!)",
                                  dataType: APIModel<[DayFoodModel]>?.self,
                                  parameter: nil,
                                  completionHandler: { [weak self] result in
            self?.foodData = result?.data
            self?.tableView.reloadData()
            
            self?.tableView.snp.updateConstraints{
                $0.height.equalTo((self?.foodData!.count)! * 170 + 50)
            }
        })
        
    }
    
    private func fetchWeekData() {
        APIManager.shared.getData(urlEndpointString: Constants.getWeekFood + "/\(selectedResName!)",
                                  dataType: APIModel<[DayFoodModel]>?.self,
                                  parameter: nil,
                                  completionHandler: { [weak self] result in

            if let result = result, let data = result.data {
                self?.weekFoodData = data.sorted(by: { $0.toDay! < $1.toDay! })
            }
            
            self?.tableView.snp.updateConstraints{
                $0.height.equalTo((self?.foodData!.count)! * 170 + 50)
            }
        })
    }

    // MARK: - Actions
    @objc func calenderButtonDidTap() {
        UIDevice.vibrate()
        let vc = WeekViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Functions
    func setUpTableView(dataSourceDelegate: UITableViewDelegate & UITableViewDataSource) {
        tableView = UITableView()
        tableView.then{
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
            $0.isScrollEnabled = false
            
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.separatorStyle = .none
        }
    }
    func setUpView() {
        self.view.addSubview(scrolleView)
        scrolleView.addSubview(contentView)
        contentView.addSubview(adImageView)
        contentView.addSubview(titleView)
        contentView.addSubview(changeDayButtonView)
        contentView.addSubview(tableView)
        contentView.addSubview(tablePageControl)
        contentView.addSubview(submitButton)

        titleView.addSubview(titleLabel)
        titleView.addSubview(operatingTimeLabel)
        
        changeDayButtonView.addSubview(goBeforeButton)
        changeDayButtonView.addSubview(goAfterButton)
    }
    func setUpConstraint() {
        
        scrolleView.snp.makeConstraints {
            $0.top.equalTo(super.navigationImgView.snp.bottom).inset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.top.bottom.equalToSuperview()
        }

        adImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(70)
        }
        
        titleView.snp.makeConstraints {
            $0.top.equalTo(adImageView.snp.bottom).offset(5)
            $0.leading.equalToSuperview()
            $0.height.equalTo(75)
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(25)
        }
        
        operatingTimeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(5)
        }
        
        changeDayButtonView.snp.makeConstraints {
            $0.top.bottom.height.equalTo(titleView)
            $0.leading.equalTo(titleView.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.2)
        }
        
        goBeforeButton.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }
        
        goAfterButton.snp.makeConstraints {
            $0.leading.equalTo(goBeforeButton.snp.trailing)
            $0.trailing.top.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleView.snp.bottom)
            $0.height.equalTo(500)
//            $0.bottom.equalToSuperview().offset(200)
        }
        
        tablePageControl.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        submitButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(69)
            $0.top.equalTo(tablePageControl.snp.bottom).offset(50)
            $0.bottom.equalToSuperview().inset(100)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
//            $0.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - TableView delegate
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = self.foodData {
            isFoodDataIsEmpty = false
            return data.count
        } else {
            isFoodDataIsEmpty = true
            
            let alert = UIAlertController(title: nil, message: "불러올 학식 정보가 없거나, \n학식 정보를 불러오는데 실패하였습니다", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none

        let itemIdx = indexPath.item
        print("itemIdx :: \(itemIdx)")
        if let foodData = self.foodData {
            cell.data = foodData[itemIdx]
            cell.isToday = self.isToday
            cell.setUpData()
            cell.setUpButtons()
        }
        return cell

    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }

    
    func setSubmitButtonCell(_ cell: UITableViewCell) {

        lazy var submitButton = UIButton().then{
            var config = UIButton.Configuration.tinted()
            var attText = AttributedString.init("학식에 대한 의견 남기기")
            
            attText.font = UIFont.NotoSansKR(size: 14, family: .Bold)
            attText.foregroundColor = UIColor.white
            config.attributedTitle = attText
            config.background.backgroundColor = .signatureBlue
            config.cornerStyle = .capsule
            
            $0.configuration = config
            $0.clipsToBounds = true
            $0.setImage(UIImage(named: "pencil"), for: .normal)
            
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.masksToBounds = false
            $0.layer.shadowOffset = CGSize(width: 0, height: 0)
            $0.layer.shadowRadius = 2
            $0.layer.shadowOpacity = 0.25
        }
        cell.contentView.addSubview(submitButton)

        submitButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(69)
            make.top.equalToSuperview().inset(70)
            make.bottom.equalToSuperview().inset(100)
            make.height.equalTo(50)
            make.centerY.centerX.equalToSuperview()
        }
        
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        
    }

    
    @objc func submitButtonTapped(_ sender: UIButton){
        let submitViewController = SubmitViewController()
        submitViewController.modalPresentationStyle = .custom
        submitViewController.modalTransitionStyle = .crossDissolve
        self.present(submitViewController, animated: true)
    }
}
// MARK: - API Success
extension MainViewController {
    // 데이터 처리
    func getResultAPI(_ result: APIModel<[DayFoodModel]>) {
        let statusCode = result.httpCode
        switch statusCode {
        case 200:
            getDayFoodAPISuccess(result.data!)
        case 405, 500:
            noFoodAPI(result)
        default: fatalError()
        }
    }
    
    //일간 조회
    func getDayFoodAPISuccess(_ result: [DayFoodModel]) {
        self.foodData = result
        hideEmptyView()
        mainTableView.reloadData()
    }
    // 405 error : 공휴일 X
    func noFoodAPI(_ result: APIModel<[DayFoodModel]>) {
        showEmptyView(result)
        mainTableView.reloadData()
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
//        let dayOfTheWeek = UILabel().then{
//            if let dayOfWeek = result.dayOfTheWeek {$0.text = dayOfWeek}
//            $0.text = "dayOfWeek"
//            $0.font = UIFont.NotoSansKR()
//            $0.textColor = .signatureBlue
//        }
        let messageLabel = UILabel().then{
            if let message = result.message {$0.text = message}
            $0.font = UIFont.NotoSansKR(size: 16, family: .Regular)
            $0.numberOfLines = 0
        }
        let backgroudView = UIView(frame: CGRect(x: 0, y: 0, width: mainTableView.bounds.width, height: mainTableView.bounds.height))
        backgroudView.addSubview(backView)
        backView.addSubview(date)
//        backView.addSubview(dayOfTheWeek)
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
//        dayOfTheWeek.snp.makeConstraints { make in
//            make.centerY.equalTo(date)
//            make.leading.equalTo(date.snp.trailing).offset(3)
//        }
        messageLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        mainTableView.backgroundView = backgroudView
    }
    func hideEmptyView() {
        mainTableView.backgroundView?.isHidden = true
    }
    
    
    func getTodayDataText(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        return formatter.string(from: date)
    }
}

extension MainViewController {
    private func setWeekDateData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        
        let today = Date()
        switch dateFormatter.string(from: Date()) {
        case "월":
            startDay = today
            tablePageControl.currentPage = 0
        case "화":
            startDay = Calendar.current.date(byAdding: .day, value: -1, to: today)
            tablePageControl.currentPage = 1
        case "수":
            startDay = Calendar.current.date(byAdding: .day, value: -2, to: today)
            tablePageControl.currentPage = 2
        case "목":
            startDay = Calendar.current.date(byAdding: .day, value: -3, to: today)
            tablePageControl.currentPage = 3
        case "금":
            startDay = Calendar.current.date(byAdding: .day, value: -4, to: today)
            tablePageControl.currentPage = 4
        default: return
        }
        setArrowButtons(currentPageControl: tablePageControl.currentPage)
        
        endDay = Calendar.current.date(byAdding: .day, value: 5, to: startDay!)
    }
    
    private func getDailyFoodData(date: Date) -> [DayFoodModel] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let filterDate = formatter.string(from: date)
        
        // TODO: filterDate(0000-00-00)과 toDay의 값이 같은 DayFoodModel만 필터링
//        let testData = [
//            DayFoodModel(mealType: "LUNCH_A", meals: [ "22-meal1", "22-meal2", "22-meal3" ], statusType: "OPEN", toDay: "2023-02-22"),
//            DayFoodModel(mealType: "LUNCH_A", meals: [ "23-meal1", "23-meal2", "23-meal3" ], statusType: "OPEN", toDay: "2023-02-23"),
//            DayFoodModel(mealType: "LUNCH_B", meals: [ "23-meal1", "23-meal2", "23-meal3" ], statusType: "OPEN", toDay: "2023-02-23"),
//            DayFoodModel(mealType: "DINNER", meals: [ "24-meal1", "24-meal2", "24-meal3" ], statusType: "OPEN", toDay: "2023-02-24"),
//            DayFoodModel(mealType: "LUNCH_A", meals: [ "20-meal1", "20-meal2", "20-meal3" ], statusType: "OPEN", toDay: "2023-02-20"),
//            DayFoodModel(mealType: "LUNCH_A", meals: [ "21-meal1", "21-meal2", "21-meal3" ], statusType: "OPEN", toDay: "2023-02-21"),
//        ]
        if let weekFoodData = self.weekFoodData { return weekFoodData.filter { $0.toDay == filterDate } }
        return []
    }
}
