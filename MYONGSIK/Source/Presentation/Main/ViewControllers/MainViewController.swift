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
        flowLayout.itemSize = CGSize(width: CGFloat.screenWidth - 30, height: 400)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 20
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.decelerationRate = .fast
        cv.isPagingEnabled = false
        cv.register(PageCell.self, forCellWithReuseIdentifier: "cell")

        return cv
    }()
    
    private let tablePageControl = UIPageControl()
    
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

//        contentView.addSubview(isEmptyDataLabel)
//
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(dateLabel)
//        contentView.addSubview(operatingTimeLabel)
//
//        contentView.addSubview(goBeforeButton)
//        contentView.addSubview(goAfterButton)
        
        contentView.addSubview(mealCollectionView)
        
//        contentView.addSubview(tablePageControl)
//
//        contentView.addSubview(submitButton)
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
            $0.height.equalTo(850)
        }
        
        mealCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupObserver() {
        MainViewModel.shared.getFoodList { [self] foodList in
            if foodList.isEmpty {
                mealCollectionView.isHidden = true
//                tablePageControl.isHidden = true
//                submitButton.isHidden = true
//                isEmptyDataLabel.isHidden = false
            }else {
                mealCollectionView.isHidden = false
//                tablePageControl.isHidden = false
//                submitButton.isHidden = false
//                isEmptyDataLabel.isHidden = true
                
                
                mealCollectionView.reloadData()
            }
        }
        
        MainViewModel.shared.getSelectedRestaurant { restaurant in
            switch restaurant {
            case .mcc, .paulbassett:
                return
            default:
                self.operatingTimeLabel.attributedText = "운영시간  |  \(restaurant.getTime())"
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
        case "월":
            currentPageNum = 0
            startDate = today
        case "화":
            currentPageNum = 1
            startDate = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        case "수":
            currentPageNum = 2
            startDate = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        case "목":
            currentPageNum = 3
            startDate = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        case "금":
            currentPageNum = 4
            startDate = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        case "토":
            currentPageNum = 0
            startDate = Calendar.current.date(byAdding: .day, value: 2, to: today)!
        case "일":
            currentPageNum = 0
            startDate = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        default:
            return
        }
    }
    
    private func getTodayDataText(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: date)
    }
    
    private func setArrowButtons() {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { return -5 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PageCell
        
        cell.setDay(page: indexPath.row)
        
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / CGFloat.screenWidth)
        if let date = Calendar.current.date(byAdding: .day, value: self.currentPageNum, to: startDate) {
            self.titleLabel.text  = "오늘의 학식  |  \(getTodayDataText(date: date))"
        }
        
        didTapChangeDateButton(value: page - currentPageNum)
   }
}

