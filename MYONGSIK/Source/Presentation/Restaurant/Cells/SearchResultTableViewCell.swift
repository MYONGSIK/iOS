//
//  SearchResultTableViewCell.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit
import RealmSwift

// MARK: 검색 페이지 > 검색 결과 셀
class SearchResultTableViewCell: UITableViewCell {
    let realm = try! Realm()
    var data: HeartListModel?
    
    // MARK: Views
    let howManyLikeLabel = UILabel().then {
        $0.text = "명지대 학생 중 00명이 담았어요!"
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
//    let heartButton = UIButton().then {
//        $0.setImage(UIImage(systemName: "heart"), for: .normal)
//        $0.setImage(UIImage(systemName: "heart.fill"), for: .selected)
//        $0.tintColor = .lightGray
//
//        $0.addTarget(self, action: #selector(didTapHeartButton(_:)), for: .touchUpInside)
//    }
    let pinImage = UIImageView().then{
        $0.image = UIImage(named: "pin")
    }
    let locationButton = UIButton().then{
        $0.setTitle("가게위치 가게위치 가게위치 가게위치 가게위치 가게위치", for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(size: 14, family: .Bold)
        $0.contentHorizontalAlignment  = .left
        $0.setTitleColor(UIColor.placeContentColor, for: .normal)
        $0.addTarget(self, action: #selector(didTapLocationButton(_:)), for: .touchUpInside)

    }
    let phoneImage = UIImageView().then{
        $0.image = UIImage(named: "phone")
    }
    let phoneNumButton = UIButton().then{
        $0.setTitle("전화번호가 없습니다.", for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(size: 14, family: .Bold)
        $0.contentHorizontalAlignment  = .left
        $0.setTitleColor(UIColor.placeContentColor, for: .normal)
        $0.addTarget(self, action: #selector(didTapLocationButton(_:)), for: .touchUpInside)
    }
    let goLinkButton = UIButton().then{
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
    
    @objc func didTapPhoneNumButton(_ sender: UIButton) {
        print("didTapPhoneNumButton called --> \(sender.titleLabel?.text)")
        // TODO: 전화앱으로 연결
    }
    
    @objc func didTapLocationButton(_ sender: UIButton) {
        print("didTapLocationButton called --> \(sender.titleLabel?.text)")
        // TODO: 네이버 지도앱으로 연결 (네이버 지도앱이 없는 경우 토스트 메세지 띄우기)
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
    func setUpView() {
//        self.contentView.addSubview(howManyLikeLabel)
        self.contentView.addSubview(backView)
        
        backView.addSubview(placeNameLabel)
        backView.addSubview(dotLabel)
        backView.addSubview(placeCategoryLabel)
        backView.addSubview(distanceLabel)
//        backView.addSubview(heartButton)
        
        backView.addSubview(goLinkButton)
        
        backView.addSubview(pinImage)
        backView.addSubview(locationButton)
        backView.addSubview(phoneImage)
        backView.addSubview(phoneNumButton)
    }
    func setUpConstraint() {
//        howManyLikeLabel.snp.makeConstraints {
//            $0.top.leading.equalToSuperview().inset(15)
//        }
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
//            make.top.equalTo(howManyLikeLabel.snp.bottom).offset(5)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        placeNameLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(22)
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
//        heartButton.snp.makeConstraints { make in
//            make.top.trailing.equalToSuperview().inset(20)
//            make.leading.equalTo(distanceLabel.snp.trailing).offset(5)
//            make.width.height.equalTo(30)
//        }
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
            make.top.equalTo(pinImage)
//            make.trailing.lessThanOrEqualTo(goLinkButton.snp.leading).offset(-42)
            make.trailing.equalToSuperview().offset(-20)
        }
        phoneImage.snp.makeConstraints { make in
            make.width.height.equalTo(15)
            make.top.equalTo(pinImage.snp.bottom).offset(24)
            make.leading.equalTo(pinImage)
        }
        phoneNumButton.snp.makeConstraints { make in
            make.leading.equalTo(locationButton)
            make.centerY.equalTo(phoneImage)
        }
    }
    
    @objc func didTapHeartButton(_ sender: UIButton) {
        print("식당 좋아요 버튼 탭함")
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.tintColor = .systemPink
            addHeartData(data: self.data)   // 로컬에 찜 추가
        }
        if !sender.isSelected {
            sender.tintColor = .lightGray
            deleteHeartData(data: self.data)    // 로컬에 찜 삭제
        }
        // TODO: 식당 좋아요 정보 서버 POST -> 업데이트 예정
    }
    
    @objc func didTapGoLinkButton() {
        guard let link = self.data?.placeUrl else {return}
        guard let placeName = self.data?.placeName else {return}
        guard let category = self.data?.category else {return}
        
        let webView = WebViewController()
        webView.webURL = link
        webView.placeName = placeName
        webView.category = category
        if let vc = self.next(ofType: UIViewController.self) { vc.navigationController?.pushViewController(webView, animated: true) }
    }
    
    // MARK: 서버에서 데이터를 받아온 후 출력시킵니다.
    func setUpData(_ data: KakaoResultModel) {
        self.data = HeartListModel(placeName: data.place_name ?? nil,
                                   category: data.category_group_name ?? nil,
                                   placeUrl: data.place_url ?? nil)
        
        if let placeName = data.place_name {self.placeNameLabel.text = placeName}
        if let category = data.category_group_name {self.placeCategoryLabel.text = category}
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
        if let location  = data.road_address_name {
//            self.locationLabel.text = location
//            if location == "" {self.locationLabel.text = "주소가 없습니다."}
            self.locationButton.setTitle(location, for: .normal)
            if location == "" {self.locationButton.setTitle("주소가 없습니다.", for: .normal)}
        }
        if let phone = data.phone {
//            self.phoneNumLabel.text = phone
//            if phone == "" {self.phoneNumLabel.text = "전화번호가 없습니다."}
            self.phoneNumButton.setTitle(phone, for: .normal)
            if phone == "" {self.phoneNumButton.setTitle("전화번호가 없습니다.", for: .normal)}
        }
    }
    
    func addHeartData(data: HeartListModel?) {
        if let data = data {
            
            let objc = HeartListData()
            objc.placeName = data.placeName
            objc.category = data.category
            objc.placeUrl = data.placeUrl
            
            try! realm.write { realm.add(objc) }
        }
    }
    
    func deleteHeartData(data: HeartListModel?) {
        if let data = data {
            let predicate = NSPredicate(format: "placeName = %@", data.placeName)
            let objc = realm.objects(HeartListData.self).filter(predicate)
            try! realm.write { realm.delete(objc) }
        }
    }
}
