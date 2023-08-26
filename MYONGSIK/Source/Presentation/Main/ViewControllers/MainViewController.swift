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
    var currentPageNum = 0

    // MARK: - Views
    private let scrolleView = UIScrollView()
    private let contentView = UIView()
    
    private let backItemButton = UIButton()

    private let tableView = UITableView()
    
    private let titleLabel = UILabel()
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
    
    private let containerView = UIView().then { $0.backgroundColor = .white }
    private let pageControlContainerView = UIView().then { $0.backgroundColor = .white }
    private let submitContainerView = UIView().then { $0.backgroundColor = .white }


    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
          
        
        
        setup()
        setupView()
        setupConstraint()
        setupObserver()
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
        operatingTimeLabel.attributedText = "운영시간  |  \(MainViewModel.shared.getRestaurant().getTime())"
            .attributed(of: "운영시간", value: [
                .foregroundColor: UIColor.darkGray
            ])

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
        tablePageControl.addTarget(self, action: #selector(pageChanged(_:)), for: .valueChanged)

        
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

//        contentView.addSubview(pageControlContainerView)
//        contentView.addSubview(submitContainerView)
//        contentView.addSubview(isEmptyDataLabel)
//
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(operatingTimeLabel)
//
//        contentView.addSubview(goBeforeButton)
//        contentView.addSubview(goAfterButton)
//
//        pageControlContainerView.addSubview(tablePageControl)
//        submitContainerView.addSubview(submitButton)
        
        contentView.addSubview(mealCollectionView)
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
        MainViewModel.shared.isFood { isFood in
            if isFood == false {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func removeAllViews() {
        [
            containerView,
            pageControlContainerView,
            submitContainerView
        ].forEach { view in
            view.removeFromSuperview()
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
    }
    
    // MARK: - Actions
    @objc private func didTapBackItemButton() {
        MainViewModel.shared.removeFoodList()
    }
    
    @objc private func pageChanged(_ sender: UIPageControl) { print("pageChanged") }

    @objc private func didTapGoBeforeButton(_ sender: UIButton) {
        didTapChangeDateButton(value: -1) }
    @objc private func didTapGoAfterButton(_ sender: UIButton) { didTapChangeDateButton(value: 1) }
    
    @objc func submitButtonTapped(_ sender: UIButton){
        let submitViewController = SubmitViewController()
        submitViewController.modalPresentationStyle = .custom
        submitViewController.modalTransitionStyle = .crossDissolve
        self.present(submitViewController, animated: true)
    }
}

// MARK: - API Success
extension MainViewController {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PageCell
        
        cell.setDay(page: indexPath.row)
        
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

