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
    // MARK: - Variables

    var isToday: Bool = true
    var isWeekend: Bool = false
    var isSunday: Bool = false
    var isFoodDataIsEmpty: Bool = false

    var selectedResName: String? = ""
    var operatingTimeText: String = ""
    var startDay: Date?
    var endDay: Date?
    
//    var mainTableView: UITableView!
    var foodData: [DayFoodModel]? = []
    var weekFoodData: [DayFoodModel]? = []
    
    
    // MARK: - Views
    let scrolleView = UIScrollView()
    let contentView = UIView()
    
    
    let backItemButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(didTapBackItemButton), for: .touchUpInside)
    }
    
//    let adImageView = UIView().then{
//        $0.backgroundColor = .systemGray4
//        $0.layer.cornerRadius = 15
//    }

    var tableView: UITableView!
    
    let titleView = UIView().then {
        $0.backgroundColor = .clear
    }

    lazy var titleLabel = UILabel().then{
        $0.text = "오늘의 학식  |  \(getTodayDataText(date: Date() + 32400))"
        $0.font = UIFont.NotoSansKR(size: 22, family: .Bold)
        $0.textColor = UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1)
    }


    lazy var operatingTimeLabel = UILabel().then{
        $0.font = UIFont.NotoSansKR(size: 12, family: .Regular)
        $0.textColor = .gray
        $0.attributedText = "운영시간  |  \(operatingTimeText)"
            .attributed(of: "운영시간", value: [
                .foregroundColor: UIColor.darkGray
            ])
        print(operatingTimeText)
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
    
    let isEmptyDataLabel = UILabel().then {
        $0.text = "* 제공된 학식 정보가 없습니다 *"
        $0.numberOfLines = 0
        $0.textColor = .lightGray
        $0.font = UIFont.NotoSansKR(size: 16, family: .Bold)
        $0.textAlignment = .center
        $0.isHidden = true
    }

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
          
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
      
        setSelectedRes()
        setWeekDateData()
        
        setUpTableView(dataSourceDelegate: self)
        setUpView()
        setUpConstraint()
        
        fetchDailyData()
        fetchWeekData()
    }
    

    // MARK: - Functions
    private func setSelectedRes() {
        if let userCampus = UserDefaults.standard.value(forKey: "userCampus") {
            switch userCampus as! String {
            case CampusInfo.seoul.name:
                selectedResName = SeoulRestaurant.mcc.rawValue
                operatingTimeText = "중식 11:30~14:00  |  석식 17:30~19:00"
                backItemButton.isHidden = true
            case CampusInfo.yongin.name:
                print("operatingTimeText - \(operatingTimeText)")
                backItemButton.isHidden = false
                return
            default: return
            }
        }
    }
    
    private func fetchDailyData() {
        var resName = selectedResName
        if selectedResName == YonginRestaurant.academy.rawValue { resName = "학생식당" }
        print(Constants.getDayFood + "/\(resName!)")
        APIManager.shared.getData(urlEndpointString: Constants.getDayFood + "/\(resName!)",
                                  dataType: APIModel<[DayFoodModel]>?.self,
                                  parameter: nil,
                                  completionHandler: { [weak self] result in
            switch result?.httpCode {
            case 200:
                // set TableView
                // 중식A - 중식B - 석식 순으로 보이도록 데이터 정렬
                self?.foodData = result?.data!.sorted(by: { $0.mealType! > $1.mealType! })
                if var data = self?.foodData {
                    
                    if (self?.selectedResName == SeoulRestaurant.mcc.rawValue) && (data.count == 3) {
                        // 중식B - 중식A - 석식 순으로 정렬되어있는 상태이므로 수정 필요
                        let temp = data[0]
                        data[0] = data[1]
                        data[1] = temp
                    }
                    
                    self?.foodData = data
                }
            
                self?.reloadDataAnimation()
                print("fetchDailyData - \(self?.foodData?.count)")
                
            case 405, 500:
                self?.showAlert(message: result?.message ?? "금일 식당운영을 하지 않습니다")
            default:
                self?.showAlert(message: "네트워크 오류 - error code : \(result?.httpCode)")
                return
            }
            
            self?.reloadDataAnimation()
            self?.checkDataIsEmpty()
        })
        
    }
    
    private func fetchWeekData() {
        var resName = selectedResName
        if selectedResName == YonginRestaurant.academy.rawValue { resName = "학생식당" }
        
        print(Constants.getWeekFood + "/\(resName!)")

        APIManager.shared.getData(urlEndpointString: Constants.getWeekFood + "/\(resName!)",
                                  dataType: APIModel<[DayFoodModel]>?.self,
                                  parameter: nil,
                                  completionHandler: { [weak self] result in

            if let result = result, let data = result.data {
                self?.weekFoodData = data.sorted(by: { $0.toDay! < $1.toDay! })
                self?.reloadDataAnimation()
            }

        })
    }

    func setUpTableView(dataSourceDelegate: UITableViewDelegate & UITableViewDataSource) {
        tableView = UITableView()
        tableView.then{
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
            $0.isScrollEnabled = false
            $0.backgroundColor = .white

            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.separatorStyle = .none
            $0.allowsSelection = false
        }
    }
    func setUpView() {
        super.navigationImgView.addSubview(backItemButton)
        
        self.view.addSubview(scrolleView)
        scrolleView.addSubview(contentView)
//        contentView.addSubview(adImageView)
        contentView.addSubview(titleView)
        contentView.addSubview(changeDayButtonView)
        contentView.addSubview(tableView)
//        contentView.addSubview(tablePageControl)
//        contentView.addSubview(submitButton)
        contentView.addSubview(isEmptyDataLabel)

        titleView.addSubview(titleLabel)
        titleView.addSubview(operatingTimeLabel)
        
        changeDayButtonView.addSubview(goBeforeButton)
        changeDayButtonView.addSubview(goAfterButton)
    }
    func setUpConstraint() {
        backItemButton.snp.makeConstraints {
            $0.width.height.equalTo(25)
            $0.centerY.equalTo(super.topLogoImg)
            $0.leading.equalToSuperview().inset(22)
        }
        
        scrolleView.snp.makeConstraints {
            $0.top.equalTo(super.navigationImgView.snp.bottom).inset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.top.bottom.equalToSuperview()
            $0.height.equalTo(1000)
        }

//        adImageView.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.leading.equalToSuperview().offset(15)
//            $0.trailing.equalToSuperview().inset(15)
//            $0.height.equalTo(70)
//        }
        
        titleView.snp.makeConstraints {
            $0.top.equalToSuperview()
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
//            $0.height.equalTo(600)
            $0.bottom.equalToSuperview()
        }
        
//        tablePageControl.snp.makeConstraints {
//            $0.top.equalTo(tableView.snp.bottom).offset(5)
//            $0.centerX.equalToSuperview()
//        }
//
//        submitButton.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview().inset(69)
//            $0.top.equalTo(tablePageControl.snp.bottom).offset(50)
//            $0.bottom.equalToSuperview().inset(100)
//            $0.height.equalTo(50)
//            $0.centerX.equalToSuperview()
////            $0.bottom.equalToSuperview()
//        }
        isEmptyDataLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(120)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func checkDataIsEmpty() {
        if foodData?.count == 0 {
            tablePageControl.isHidden = true
            submitButton.isHidden = true
            isEmptyDataLabel.isHidden = false
        } else {
            tablePageControl.isHidden = false
            submitButton.isHidden = false
            isEmptyDataLabel.isHidden = true
            
//            tableView.snp.updateConstraints{
//                $0.height.equalTo(foodData!.count * 180)
//            }
        }
    }
    
    private func setArrowButtons(currentPageControl: Int) {
        goBeforeButton.isEnabled = true; goBeforeButton.tintColor = .signatureBlue
        goAfterButton.isEnabled = true; goAfterButton.tintColor = .signatureBlue
        switch currentPageControl {
        case 0:
            goBeforeButton.isEnabled = false; goBeforeButton.tintColor = .lightGray
        case tablePageControl.numberOfPages-1:
            goAfterButton.isEnabled = false; goAfterButton.tintColor = .lightGray
        default:
            return
        }
    }

    private func didTapChangeDateButton(value: Int) {
        tablePageControl.currentPage += value
        setArrowButtons(currentPageControl: tablePageControl.currentPage)
        
        // set titleLabel
        if let start = startDay {
            DispatchQueue.main.async {
                
                let date = Calendar.current.date(byAdding: .day, value: self.tablePageControl.currentPage, to: start)
                self.titleLabel.text  = "오늘의 학식  |  \(self.getTodayDataText(date: date!))"
                
                // set daily food data
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(identifier: "UTC")
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let today = Date() + 32400
                if dateFormatter.string(from: date!) == dateFormatter.string(from: today) { self.isToday = true }
                else { self.isToday = false }
                
                self.foodData = self.getDailyFoodData(date: date!)
                self.checkDataIsEmpty()
                
                self.reloadDataAnimation()
            }
        }
    }
    
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
            make.height.equalTo(50)
            make.centerY.centerX.equalToSuperview()
        }

        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)

    }
    
    // MARK: - Actions
    @objc private func didTapBackItemButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func pageChanged(_ sender: UIPageControl) { print("pageChanged") }

    @objc private func didTapGoBeforeButton(_ sender: UIButton) { didTapChangeDateButton(value: -1) }
    @objc private func didTapGoAfterButton(_ sender: UIButton) { didTapChangeDateButton(value: 1) }
    
    @objc func submitButtonTapped(_ sender: UIButton){
        let submitViewController = SubmitViewController()
        submitViewController.modalPresentationStyle = .custom
        submitViewController.modalTransitionStyle = .crossDissolve
        self.present(submitViewController, animated: true)
    }
}

// MARK: - TableView delegate
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = self.foodData {
            isFoodDataIsEmpty = false
            return data.count + 2
        } else {
            isFoodDataIsEmpty = true
            
            let alert = UIAlertController(title: nil, message: "불러올 학식 정보가 없습니다", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == foodData!.count {
            let cell = UITableViewCell()
            cell.addSubview(tablePageControl)
            tablePageControl.snp.makeConstraints {
                $0.centerX.centerY.equalToSuperview()
            }
            return cell
        } else if indexPath.row == foodData!.count + 1 {
            let cell = UITableViewCell()
            self.setSubmitButtonCell(cell)
            return cell
        }

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
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }

}

// MARK: - API Success
extension MainViewController {
//    // 데이터 처리
//    func getResultAPI(_ result: APIModel<[DayFoodModel]>) {
//        let statusCode = result.httpCode
//        switch statusCode {
//        case 200:
//            getDayFoodAPISuccess(result.data!)
//        case 405, 500:
//            noFoodAPI(result)
//        default: fatalError()
//        }
//    }
//
//    //일간 조회
//    func getDayFoodAPISuccess(_ result: [DayFoodModel]) {
//        self.foodData = result
//        hideEmptyView()
//        mainTableView.reloadData()
//    }
    // 405 error : 공휴일 X
//    func noFoodAPI(_ result: APIModel<[DayFoodModel]>) {
//        showEmptyView(result)
//        mainTableView.reloadData()
//    }
//
//    // Tableview
//    func showEmptyView(_ result: APIModel<[DayFoodModel]>) {
//        let backView = UIView().then{
//            $0.backgroundColor = .white
//            $0.clipsToBounds = true
//            $0.layer.cornerRadius = 10
//            $0.layer.borderColor = UIColor.borderColor.cgColor
//            $0.layer.borderWidth = 1
//        }
//        let date = UILabel().then{
//            if let localDateTime = result.localDateTime {
//                $0.text = FormatManager().localDateTimeToDate(localDateTime: localDateTime)
//            }
//            $0.font = UIFont.NotoSansKR()
//            $0.textColor = .signatureBlue
//        }
//        let messageLabel = UILabel().then{
//            if let message = result.message {$0.text = message}
//            $0.font = UIFont.NotoSansKR(size: 16, family: .Regular)
//            $0.numberOfLines = 0
//        }
//        let backgroudView = UIView(frame: CGRect(x: 0, y: 0, width: mainTableView.bounds.width, height: mainTableView.bounds.height))
//        backgroudView.addSubview(backView)
//        backView.addSubview(date)
//        backView.addSubview(messageLabel)
//
//        backView.snp.makeConstraints { make in
//            make.centerY.centerX.equalToSuperview()
//            make.leading.trailing.equalToSuperview().inset(21)
//            make.height.equalTo(178)
//        }
//        date.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(23)
//            make.top.equalToSuperview().offset(19)
//        }
//        messageLabel.snp.makeConstraints { make in
//            make.centerX.centerY.equalToSuperview()
//        }
//
//        mainTableView.backgroundView = backgroudView
//    }
//    func hideEmptyView() {
//        mainTableView.backgroundView?.isHidden = true
//    }
//
    
    func getTodayDataText(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: date)
    }
}

extension MainViewController {
    private func setWeekDateData() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "EE"
        
        let today = Date() + 32400
        print("today - \(today)")
        switch dateFormatter.string(from: today) {
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
        case "토":
            isWeekend = true
            startDay = Calendar.current.date(byAdding: .day, value: -5, to: today)
            tablePageControl.currentPage = 4
            showAlert(message: "주말에는 학생식당을 운영하지 않습니다.")
        case "일":
            isWeekend = true
            isSunday = true
            startDay = Calendar.current.date(byAdding: .day, value: 1, to: today)
            tablePageControl.currentPage = 0
            showAlert(message: "주말에는 학생식당을 운영하지 않습니다.")
        default: return
        }
        setArrowButtons(currentPageControl: tablePageControl.currentPage)
        
        endDay = Calendar.current.date(byAdding: .day, value: 4, to: startDay!)
        
        // 일요일 테스트 용
//        startDay = Calendar.current.date(byAdding: .day, value: 1, to: today)
//        endDay = Calendar.current.date(byAdding: .day, value: 4, to: startDay!)
        print("startDay - \(startDay)")
        print("endDay - \(endDay)")
        
        if isWeekend { titleLabel.text = "오늘의 학식  |  \(getTodayDataText(date: endDay!))" }
        if isSunday { titleLabel.text = "오늘의 학식  |  \(getTodayDataText(date: startDay!))" }
    }
    
    private func getDailyFoodData(date: Date) -> [DayFoodModel] {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd"
        let filterDate = formatter.string(from: date)
        
        if var weekFoodData = self.weekFoodData {
            weekFoodData = weekFoodData.filter { $0.toDay == filterDate }
            weekFoodData = weekFoodData.sorted(by: { $0.mealType! > $1.mealType! })
            
            if weekFoodData.count == 3 {
                // 중식B - 중식A - 석식 순으로 정렬되어있는 상태이므로 수정 필요
                let temp = weekFoodData[0]
                weekFoodData[0] = weekFoodData[1]
                weekFoodData[1] = temp
            }
            
            return weekFoodData
        }
        return []
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    func reloadDataAnimation() {
        print("reloadDataAnimation called")
        // reload data with animation
        UIView.transition(with: self.tableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
                          self.tableView.reloadData()},
                          completion: nil);
    }
}
