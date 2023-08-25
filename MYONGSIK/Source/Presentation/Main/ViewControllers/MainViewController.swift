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

enum Height: Int {
    case food3 = 510
    case food2 = 400
}

class MainViewController: MainBaseViewController {
    // MARK: - Variables
    
    let mainViewModel = MainViewModel()
    
    var currentPageNum = 0

    var isToday: Bool = true
    var isWeekend: Bool = false
    var isSunday: Bool = false
    var isFoodDataIsEmpty: Bool = false

    var selectedResName: String? = ""
    var operatingTimeText: String = ""
    var startDay: Date?
    var endDay: Date?
    
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
    
    var containerView = UIView().then { $0.backgroundColor = .white }
    var pageControlContainerView = UIView().then { $0.backgroundColor = .white }
    var submitContainerView = UIView().then { $0.backgroundColor = .white }
    var mealCollectionView: UICollectionView!

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
          
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
       
    
        setupCollectionView()
        setUpView()
        setUpConstraint()
        
        

        DispatchQueue.main.async {
            self.mealCollectionView.scrollToItem(at: IndexPath(item: self.currentPageNum, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
     
    private func showUpdateAlert() {
        if let userCampus = UserDefaults.standard.value(forKey: "userCampus") {
            if userCampus as! String == CampusInfo.seoul.name  {
                if UserDefaults.standard.value(forKey: "StopAlert") == nil  {
                    let updateAlert = UpdateBottomAlertViewController()
                    updateAlert.modalPresentationStyle = .overFullScreen
                    self.present(updateAlert, animated: true)
                }
            }
        }
    }
    
    

    // MARK: - Functions

    
    private func removeAllViews() {
        [
            containerView,
            pageControlContainerView,
            submitContainerView
        ].forEach { view in
            view.removeFromSuperview()
        }
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
    
    func setupCollectionView() {
        mealCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then{
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.itemSize = CGSize(width: self.view.frame.width-15, height: 300)
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 10

            $0.collectionViewLayout = flowLayout
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .white
            
            $0.showsHorizontalScrollIndicator = false
            
            $0.decelerationRate = .fast
            $0.isPagingEnabled = false

            $0.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        }
    }
    
    func setUpView() {
        super.navigationImgView.addSubview(backItemButton)
        
        self.view.addSubview(scrolleView)
        scrolleView.addSubview(contentView)
        contentView.addSubview(titleView)
        contentView.addSubview(changeDayButtonView)

        contentView.addSubview(containerView)
        contentView.addSubview(pageControlContainerView)
        contentView.addSubview(submitContainerView)
        contentView.addSubview(isEmptyDataLabel)

        titleView.addSubview(titleLabel)
        titleView.addSubview(operatingTimeLabel)
        
        changeDayButtonView.addSubview(goBeforeButton)
        changeDayButtonView.addSubview(goAfterButton)
        
        pageControlContainerView.addSubview(tablePageControl)
        submitContainerView.addSubview(submitButton)
        
        containerView.addSubview(mealCollectionView)
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
            $0.height.equalTo(850)
        }

        
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

        isEmptyDataLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(120)
            $0.centerX.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo( Height.food3.rawValue)
            make.top.equalTo(titleView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        mealCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        pageControlContainerView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.top.equalTo(containerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        tablePageControl.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        submitContainerView.snp.makeConstraints { make in
            make.top.equalTo(pageControlContainerView.snp.bottom)
//            make.height.equalTo(200)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        submitButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(300)
            make.top.equalToSuperview().offset(25)
            make.centerX.equalToSuperview()
        }
    }
    

    private func checkWeekDataIsEmpty() {
        if weekFoodData?.count == 0 {
            removeAllViews()
            containerView.isHidden = true
            pageControlContainerView.isHidden = true
            submitContainerView.isHidden = true
            isEmptyDataLabel.isHidden = false
        } else {
            setUpView()
            setUpConstraint()
            containerView.isHidden = false
            pageControlContainerView.isHidden = false
            submitContainerView.isHidden = false
            isEmptyDataLabel.isHidden = true
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
        currentPageNum += value
        setArrowButtons(currentPageControl: currentPageNum)
        
        DispatchQueue.main.async {
            self.mealCollectionView.scrollToItem(at: IndexPath(item: self.currentPageNum, section: 0), at: .centeredHorizontally, animated: false)
            if let start = self.startDay {
                let date = Calendar.current.date(byAdding: .day, value: self.currentPageNum, to: start)
                self.titleLabel.text  = "오늘의 학식  |  \(self.getTodayDataText(date: date!))"
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

    @objc private func didTapGoBeforeButton(_ sender: UIButton) {
        didTapChangeDateButton(value: -1) }
    @objc private func didTapGoAfterButton(_ sender: UIButton) { didTapChangeDateButton(value: 1) }
    
    @objc func submitButtonTapped(_ sender: UIButton){
        let submitViewController = SubmitViewController()
        submitViewController.area = self.selectedResName
        submitViewController.modalPresentationStyle = .custom
        submitViewController.modalTransitionStyle = .crossDissolve
        self.present(submitViewController, animated: true)
    }
}

// MARK: - API Success
extension MainViewController {
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
        
        switch dateFormatter.string(from: today) {
        case "월":
            startDay = today
            currentPageNum = 0
        case "화":
            startDay = Calendar.current.date(byAdding: .day, value: -1, to: today)
            currentPageNum = 1
        case "수":
            startDay = Calendar.current.date(byAdding: .day, value: -2, to: today)
            currentPageNum = 2
        case "목":
            startDay = Calendar.current.date(byAdding: .day, value: -3, to: today)
            currentPageNum = 3
        case "금":
            startDay = Calendar.current.date(byAdding: .day, value: -4, to: today)
            currentPageNum = 4
        case "토":
            isWeekend = true
            startDay = Calendar.current.date(byAdding: .day, value: -5, to: today)
            tablePageControl.currentPage = 4
            currentPageNum = 4
            showAlert(message: "주말에는 학생식당을 운영하지 않습니다.")
        case "일":
            isSunday = true
            startDay = Calendar.current.date(byAdding: .day, value: 1, to: today)
            tablePageControl.currentPage = 0
            currentPageNum = 0
            showAlert(message: "주말에는 학생식당을 운영하지 않습니다.")
        default: return
        }
        tablePageControl.currentPage = currentPageNum
        setArrowButtons(currentPageControl: tablePageControl.currentPage)
        
        endDay = Calendar.current.date(byAdding: .day, value: 4, to: startDay!)
        
        if isWeekend { titleLabel.text = "오늘의 학식  |  \(getTodayDataText(date: endDay!))" }
        if isSunday { titleLabel.text = "오늘의 학식  |  \(getTodayDataText(date: startDay!))" }
    }
    
    private func getDailyFoodData(date: Date) -> [DayFoodModel] {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd"
        
        var filterDate = ""
        
        if isSunday {
            filterDate = formatter.string(from: date+1)
        }else {
            filterDate = formatter.string(from: date)
        }
        
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
        UIView.transition(with: self.mealCollectionView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
                          self.mealCollectionView.reloadData()},
                          completion: nil);
        tablePageControl.currentPage = currentPageNum
    }
}


extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return 5 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            if let start = self.startDay {
                let date = Calendar.current.date(byAdding: .day, value: self.currentPageNum, to: start)
                self.titleLabel.text  = "오늘의 학식  |  \(self.getTodayDataText(date: date!))"
            }
        }
        
        let width = scrollView.bounds.size.width
        let x = scrollView.contentOffset.x + (width/2)
        
        currentPageNum = Int(x / width)
        if tablePageControl.currentPage != currentPageNum {
            tablePageControl.currentPage = currentPageNum
        }
        
        setArrowButtons(currentPageControl: currentPageNum)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { return -5 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        cell.tag = indexPath.row
        
        cell.isToday = self.isToday
        cell.isWeekend = self.isWeekend
        cell.isFoodDataIsEmpty = self.isFoodDataIsEmpty
        cell.selectedResName = self.selectedResName

        cell.tableView.reloadData()
        
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
       guard let layout = mealCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
       
       let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
       
       let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
       let index: Int
       if velocity.x > 0 {
           index = Int(ceil(estimatedIndex))
       } else if velocity.x < 0 {
           index = Int(floor(estimatedIndex))
       } else {
           index = Int(round(estimatedIndex))
       }
       
       targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
   }
}

