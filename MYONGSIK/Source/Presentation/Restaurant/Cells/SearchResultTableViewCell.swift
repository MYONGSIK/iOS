//
//  SearchResultTableViewCell.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit

protocol RestaurantCellDelegate {
    func showToast(message: String)
}

enum CellTodo {
    case main
    case random
    case search
}

// MARK: 검색 페이지 > 검색 결과 셀
class SearchResultTableViewCell: UITableViewCell {
    var storeData: RestaurantModel?
    var data: ResponseHeartModel?
    var delegate: RestaurantCellDelegate?
    
    // MARK: Views
    let howManyLikeLabel = UILabel().then {
        $0.text = "명지대학생들이 00명이 담았어요!"
        $0.font = UIFont.NotoSansKR(size: 14, family: .Bold)
        $0.textColor = .signatureBlue
    }
    let backView = UIView().then{
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        // Shadow
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.masksToBounds = false
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.layer.shadowRadius = 4
        $0.layer.shadowOpacity = 0.2
    }
    let placeNameLabel = UILabel().then{
        $0.text = "식당이름·"
        $0.font = UIFont.NotoSansKR(size: 20, family: .Bold)
        $0.numberOfLines = 1
        $0.setContentCompressionResistancePriority(UILayoutPriority(251), for: .horizontal)
    }
    let dotLabel = UILabel().then{
        $0.text = " · "
        $0.font = UIFont.NotoSansKR(size: 20, family: .Bold)
        $0.textColor = .placeContentColor
    }
    let placeCategoryLabel = UILabel().then{
        $0.text = "가게종류"
        $0.font = UIFont.NotoSansKR(size: 13, family: .Bold)
        $0.textColor = .placeContentColor
    }
    let distanceLabel = PaddingLabel().then{
        $0.text = "320m"
        $0.font = UIFont.NotoSansKR(size: 13, family: .Bold)
        $0.textColor = .signatureBlue
    }

    let pinImage = UIImageView().then{
        $0.image = UIImage(named: "pin")
    }
    lazy var locationButton = UIButton().then{
        $0.setTitle("가게위치 가게위치 가게위치 가게위치 가게위치 가게위치", for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(size: 13, family: .Bold)
        $0.contentHorizontalAlignment  = .left
        $0.setTitleColor(UIColor.placeContentColor, for: .normal)
        $0.addTarget(self, action: #selector(didTapLocationButton(_:)), for: .touchUpInside)
        
    }
    let phoneImage = UIImageView().then{
        $0.image = UIImage(named: "phone")
    }
    lazy var phoneNumButton = UIButton().then{
        $0.setTitle("전화번호가 없습니다.", for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(size: 13, family: .Bold)
        $0.contentHorizontalAlignment  = .left
        $0.setTitleColor(UIColor.placeContentColor, for: .normal)
        $0.addTarget(self, action: #selector(didTapPhoneNumButton(_:)), for: .touchUpInside)
    }
    lazy var goLinkButton = UIButton().then{
        $0.setTitle("바로 가기", for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(size: 16, family: .Bold)

        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.clipsToBounds = true

        $0.tintColor = .white
        $0.backgroundColor = .signatureBlue
        $0.layer.cornerRadius = 15
        
        $0.addTarget(self, action: #selector(didTapGoLinkButton), for: .touchUpInside)
    }
    
    
    // MARK: Life Cycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpView()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    func deleteAllSubViews() {
        [
            howManyLikeLabel,
            backView,
            placeNameLabel,
            dotLabel,
            placeCategoryLabel,
            distanceLabel,
            goLinkButton,
            pinImage,
            locationButton,
            phoneImage,
            phoneNumButton
            
        ].forEach { subView in
            subView.removeFromSuperview()
        }
    }
    
    func setUpView() {
        self.contentView.addSubview(howManyLikeLabel)
        self.contentView.addSubview(backView)
        
        backView.addSubview(placeNameLabel)
        backView.addSubview(dotLabel)
        backView.addSubview(placeCategoryLabel)
        backView.addSubview(distanceLabel)
        
        backView.addSubview(goLinkButton)
        
        backView.addSubview(pinImage)
        backView.addSubview(locationButton)
        backView.addSubview(phoneImage)
        backView.addSubview(phoneNumButton)
    }
    func setUpConstraint() {
        howManyLikeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().inset(22)
        }
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(howManyLikeLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview().inset(10)
        }
        placeNameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(22)
        }
        dotLabel.snp.makeConstraints { make in
            make.leading.equalTo(placeNameLabel.snp.trailing)
            make.centerY.equalTo(placeNameLabel)
        }
        placeCategoryLabel.snp.makeConstraints { make in
            make.leading.equalTo(dotLabel.snp.trailing)
            make.centerY.equalTo(dotLabel)
        }
        distanceLabel.snp.makeConstraints { make in
            make.leading.equalTo(placeCategoryLabel.snp.trailing).offset(8)
            make.centerY.equalTo(placeCategoryLabel)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)  //
        }

        goLinkButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.bottom.trailing.equalToSuperview().inset(20)
        }
        pinImage.snp.makeConstraints { make in
            make.width.height.equalTo(19)
            make.leading.equalToSuperview().offset(19)
            make.top.equalTo(placeNameLabel.snp.bottom).offset(14)
        }
        locationButton.snp.makeConstraints { make in
            make.leading.equalTo(pinImage.snp.trailing).offset(10)
            make.top.centerY.equalTo(pinImage)
            make.trailing.equalToSuperview().offset(-20)
        }
        phoneImage.snp.makeConstraints { make in
            make.width.height.equalTo(15)
            make.top.equalTo(pinImage.snp.bottom).offset(15)
            make.leading.equalTo(pinImage)
        }
        phoneNumButton.snp.makeConstraints { make in
            make.leading.equalTo(locationButton)
            make.centerY.equalTo(phoneImage)
        }
    }
    
    private func setNoHowManyLabelConstraints() {
        howManyLikeLabel.removeFromSuperview()

        /// set constraints
        self.backView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
        }
        self.placeNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
        }
        self.pinImage.snp.makeConstraints {
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(25)
        }
        self.phoneImage.snp.makeConstraints {
            $0.top.equalTo(pinImage.snp.bottom).offset(22)
        }
        
    }
    
    @objc func didTapHeartButton(_ sender: UIButton) {
        print("식당 좋아요 버튼 탭함")
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.tintColor = .systemPink
            // MARK: - 서버와 통신 해 찜 추가로 변경
        }
        if !sender.isSelected {
            sender.tintColor = .lightGray
            // MARK: - 서버와 통신 해 찜 삭제로 변경
        }
    }
    
    @objc func didTapGoLinkButton() {
        print("didTapGoLinkButton")
        guard let link = self.data?.urlAddress else {return}
        guard let placeName = self.data?.name else {return}
        guard let category = self.data?.category else {return}
        
        let webView = WebViewController()
        webView.storeData = storeData
//        print("웹뷰로 넘어가는 데이터 - \(storeData)")
        webView.webURL = link
        webView.placeName = placeName
        webView.category = category
        if let vc = self.next(ofType: UIViewController.self) { vc.navigationController?.pushViewController(webView, animated: true) }
    }
    
    @objc func didTapPhoneNumButton(_ sender: UIButton) {
        if let phoneNum = sender.titleLabel?.text {
            let url = "tel://\(phoneNum)"
            
            if let openApp = URL(string: url), UIApplication.shared.canOpenURL(openApp) {
                if #available(iOS 10.0, *) { UIApplication.shared.open(openApp, options: [:], completionHandler: nil) }
                else { UIApplication.shared.openURL(openApp) }
            }
            else { delegate?.showToast(message: "번호가 등록되어있지 않습니다!") }
        }
        else { delegate?.showToast(message: "번호가 등록되어있지 않습니다!") }
    }
    
    @objc func didTapLocationButton(_ sender: UIButton) {
        if let location = sender.titleLabel?.text {
            
            let urlStr = "nmap://search?query=" + location
            let encodedStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            if let url = URL(string: encodedStr), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else { delegate?.showToast(message: "네이버 지도앱이 설치되어있지 않습니다!") }
        }
    }
    
    func setupRestaurant(_ data: RestaurantModel, _ cellMode: CellMode) {
        self.storeData = data
        
        if cellMode == .rankCell {
            if let count = data.scrapCount {self.howManyLikeLabel.text = "명지대학생들이 \(count)명이 담았어요!"}
        }
        if let placeName = data.name {self.placeNameLabel.text = placeName}
        if let category = data.category {self.placeCategoryLabel.text = category}
        if let distance = data.distance {
            guard let distanceInt = Int(distance) else {return}
            if distanceInt >= 1000 {
                let distanceKmFirst = distanceInt / 1000
                let distanceKmSecond = (distanceInt % 1000) / 100
                self.distanceLabel.text = "\(distanceKmFirst).\(distanceKmSecond)km"
            } else {
                self.distanceLabel.text = "\(distanceInt)m"
            }
        }
        if let location  = data.address {
            self.locationButton.setTitle(location, for: .normal)
            if location == "" {
                self.locationButton.setTitle("주소가 없습니다.", for: .normal)
                self.storeData?.address = "주소가 없습니다."
            } else {
                let attributedString = NSMutableAttributedString.init(string: location)
                attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 0, length: location.count))
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.signatureGray, range: NSRange.init(location: 0, length: location.count))
                self.locationButton.setAttributedTitle(attributedString, for: .normal)
            }
        }
        if let phone = data.contact {
            self.phoneNumButton.setTitle(phone, for: .normal)
            if phone == "" {
                self.phoneNumButton.setTitle("전화번호가 없습니다.", for: .normal)
                self.storeData?.contact = "전화번호가 없습니다."
            } else {
                let attributedString = NSMutableAttributedString.init(string: phone)
                attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 0, length: phone.count))
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.signatureGray, range: NSRange.init(location: 0, length: phone.count))
                self.phoneNumButton.setAttributedTitle(attributedString, for: .normal)
            }
        }
        if let longitude = data.longitude { self.storeData?.longitude = longitude }
        if let latitude = data.latitude { self.storeData?.latitude = latitude }
        
        if cellMode == .rankCell {
            setupLayout(todo: .main)
        }else {
            setupLayout(todo: .random)
        }
    }
    
    func setupLayout(todo: CellTodo) {
        switch todo {
        case .main:
            deleteAllSubViews()
            setUpView()
            setUpConstraint()
        default:
            setUpView()
            setNoHowManyLabelConstraints()
        }
    }
    
}
