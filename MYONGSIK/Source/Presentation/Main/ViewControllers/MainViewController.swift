//
//  ViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/18.
//

import UIKit
import SnapKit

class MainViewController: MainBaseViewController {
    // MARK: - Variables
    private var currentPageNum = 0
    private var startDate = Date()

    // MARK: - Views
    private let scrolleView = UIScrollView()
    private let contentView = UIView()
    
    private let backItemButton = UIButton()

    private let tableView = UITableView()
    
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let operatingTimeLabel = UILabel()
    
    private let goBeforeButton = UIButton()
    private let goAfterButton = UIButton()
    
    private let mealCollectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: CGFloat.screenWidth, height: 400)
        flowLayout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.decelerationRate = .fast
        cv.isPagingEnabled = false
        
        cv.register(PageCell.self, forCellWithReuseIdentifier: "cell")

        return cv
    }()
    
    private let tablePageControl = UIPageControl()
    private let tablePageView = UIView()
    
    private let submitButton = UIButton()
    
    private let isEmptyDataLabel = UILabel()



    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
          
        setup()
        setupView()
        setupConstraint()
        setupObserver()
        setupCurrentPage()
    }
    
    private func setup() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        
        
        backItemButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backItemButton.tintColor = .white
        backItemButton.addTarget(self, action: #selector(didTapBackItemButton), for: .touchUpInside)
        

        titleLabel.text = "오늘의 학식  | "
        titleLabel.font = UIFont.NotoSansKR(size: 22, family: .Bold)
        titleLabel.textColor = UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1)
        
        
        operatingTimeLabel.font = UIFont.NotoSansKR(size: 12, family: .Regular)
        operatingTimeLabel.textColor = .gray
        

        mealCollectionView.delegate = self
        mealCollectionView.dataSource = self
        
        goBeforeButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        goBeforeButton.tintColor = .signatureBlue
        goBeforeButton.addTarget(self, action: #selector(didTapGoBeforeButton(_:)), for: .touchUpInside)
        
        goAfterButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        goAfterButton.tintColor = .signatureBlue
        goAfterButton.addTarget(self, action: #selector(didTapGoAfterButton(_:)), for: .touchUpInside)
        
        tablePageControl.numberOfPages = 5
        tablePageControl.backgroundStyle = .minimal
        tablePageControl.pageIndicatorTintColor = .lightGray
        tablePageControl.currentPageIndicatorTintColor = .signatureBlue

        
        var config = UIButton.Configuration.tinted()
        var attText = AttributedString.init("학식에 대한 의견 남기기")
        
        attText.font = UIFont.NotoSansKR(size: 14, family: .Bold)
        attText.foregroundColor = UIColor.white
        config.attributedTitle = attText
        config.background.backgroundColor = .signatureBlue
        config.cornerStyle = .capsule
        
        submitButton.configuration = config
        submitButton.clipsToBounds = true
        submitButton.setImage(UIImage(named: "pencil"), for: .normal)
        submitButton.layer.shadowColor = UIColor.black.cgColor
        submitButton.layer.masksToBounds = false
        submitButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        submitButton.layer.shadowRadius = 2
        submitButton.layer.shadowOpacity = 0.25
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
     
        isEmptyDataLabel.text = "* 제공된 학식 정보가 없습니다 *"
        isEmptyDataLabel.numberOfLines = 0
        isEmptyDataLabel.textColor = .lightGray
        isEmptyDataLabel.font = UIFont.NotoSansKR(size: 16, family: .Bold)
        isEmptyDataLabel.textAlignment = .center
        isEmptyDataLabel.isHidden = true
    }
    
    
    func setupView() {
        super.navigationImgView.addSubview(backItemButton)
        
        self.view.addSubview(scrolleView)
        
        scrolleView.addSubview(contentView)

        contentView.addSubview(isEmptyDataLabel)

        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(operatingTimeLabel)

        contentView.addSubview(goBeforeButton)
        contentView.addSubview(goAfterButton)
        
        contentView.addSubview(mealCollectionView)
        
        contentView.addSubview(tablePageControl)

        contentView.addSubview(submitButton)
    }
    
    func setupConstraint() {
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
            $0.height.equalTo(CGFloat.screenHeight + 50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(15)
        }
        
        operatingTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalToSuperview().offset(16)
        }
        
        goAfterButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(15)
            make.width.height.equalTo(50)
        }
        
        goBeforeButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalTo(goAfterButton.snp.leading).inset(10)
            make.width.height.equalTo(50)
        }
        
        mealCollectionView.snp.makeConstraints { make in
            make.top.equalTo(operatingTimeLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(MainViewModel.shared.getRestaurantFoodCount() * 150)
        }
        
        
        tablePageControl.snp.makeConstraints { make in
            make.top.equalTo(mealCollectionView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
        
        submitButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tablePageControl.snp.bottom).offset(30)
            make.width.equalTo(245)
            make.height.equalTo(50)
        }
      
        
        isEmptyDataLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat.screenHeight / 3)
            make.centerX.equalToSuperview()
        }
        
        
        
        
    }
    
    private func setupObserver() {
        MainViewModel.shared.getFoodList { [self] foodList in
            if foodList.isEmpty {
                scrolleView.isScrollEnabled = false
                mealCollectionView.isHidden = true
                tablePageControl.isHidden = true
                submitButton.isHidden = true
                isEmptyDataLabel.isHidden = false
            }else {
                scrolleView.isScrollEnabled = true
                mealCollectionView.isHidden = false
                tablePageControl.isHidden = false
                submitButton.isHidden = false
                isEmptyDataLabel.isHidden = true

                mealCollectionView.reloadData()
            }
        }
        
        MainViewModel.shared.getSelectedRestaurant { restaurant in
            switch restaurant {
            case .mcc, .paulbassett:
                return
            default:
                self.operatingTimeLabel.attributedText = "운영시간  |  \(restaurant.getResTime())"
                    .attributed(of: "운영시간", value: [
                        .foregroundColor: UIColor.darkGray
                ])
            }
        }
    }
    
    private func setupCurrentPage() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier:"ko_KR")
        let convertStr = formatter.string(from: date)
        
        let today = Date() + 32400
        
        switch convertStr {
        case "월요일":
            currentPageNum = 0
            startDate = today
        case "화요일":
            currentPageNum = 1
            startDate = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        case "수요일":
            currentPageNum = 2
            startDate = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        case "목요일":
            currentPageNum = 3
            startDate = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        case "금요일":
            currentPageNum = 4
            startDate = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        case "토요일":
            currentPageNum = 0
            startDate = Calendar.current.date(byAdding: .day, value: 2, to: today)!
        case "일요일":
            currentPageNum = 0
            startDate = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        default:
            return
        }
        
        print(currentPageNum)
        
        getTodayDataText()
        setArrowButtons()
    }
    
    private func getTodayDataText() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        
        
        if let date = Calendar.current.date(byAdding: .day, value: self.currentPageNum, to: startDate) {
            print(formatter.string(from: date))
            self.titleLabel.text  = "오늘의 학식  |  \(formatter.string(from: date))"
        }
    }
    
    private func setArrowButtons() {
        tablePageControl.currentPage = currentPageNum
        
        goBeforeButton.isEnabled = true; goBeforeButton.tintColor = .signatureBlue
        goAfterButton.isEnabled = true; goAfterButton.tintColor = .signatureBlue
        
        if currentPageNum == 0 {
            goBeforeButton.isEnabled = false; goBeforeButton.tintColor = .lightGray
        }else if currentPageNum == 4 {
            goAfterButton.isEnabled = false; goAfterButton.tintColor = .lightGray
        }

    }

    private func didTapChangeDateButton(value: Int) {
        currentPageNum += value
        
        let indexPath = IndexPath(item: currentPageNum, section: 0)
        mealCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        getTodayDataText()
        setArrowButtons()
    }
    
    
    @objc private func didTapBackItemButton() {
        MainViewModel.shared.removeFoodList()
        self.navigationController?.popViewController(animated: true)
    }
    

    @objc private func didTapGoBeforeButton(_ sender: UIButton) {didTapChangeDateButton(value: -1) }
    @objc private func didTapGoAfterButton(_ sender: UIButton) { didTapChangeDateButton(value: 1) }
    
    @objc func submitButtonTapped(_ sender: UIButton){
        let submitViewController = SubmitViewController()
        submitViewController.modalPresentationStyle = .custom
        submitViewController.modalTransitionStyle = .crossDissolve
        self.present(submitViewController, animated: true)
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return 5 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PageCell
        
        cell.setDay(page: indexPath.row)
        
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = self.mealCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
       
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
       
        if index > -1 && index < 5 {
            currentPageNum = index
            getTodayDataText()
            setArrowButtons()
        }
        
        
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
    }
    
    
}

