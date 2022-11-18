//
//  SearchResultTableViewCell.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit

// MARK: 검색 페이지 > 검색 결과 셀
class SearchResultTableViewCell: UITableViewCell {
    // MARK: Views
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
        $0.backgroundColor = .signatureBlue
        $0.font = UIFont.NotoSansKR(size: 10, family: .Bold)
        $0.textColor = .white
        
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.setContentCompressionResistancePriority(UILayoutPriority(252), for: .horizontal)
    }
    let pinImage = UIImageView().then{
        $0.image = UIImage(named: "pin")
    }
    let locationLabel = UILabel().then{
        $0.text = "가게위치 가게위치 가게위치 가게위치 가게위치 가게위치"
        $0.font = UIFont.NotoSansKR(size: 13, family: .Bold)
        $0.textColor = .placeContentColor
        $0.numberOfLines = 2
    }
    let phoneImage = UIImageView().then{
        $0.image = UIImage(named: "phone")
    }
    let phoneNumLabel = UILabel().then{
        $0.text = "전화번호가 없습니다."
        $0.font = UIFont.NotoSansKR(size: 13, family: .Bold)
        $0.textColor = .placeContentColor
        $0.numberOfLines = 1
    }
    let goLinkButton = UILabel().then{
        $0.text = "바로 가기"
        $0.font = UIFont.NotoSansKR(size: 16, family: .Bold)
        $0.textColor = .signatureBlue
    }
    let goLinkImageButton = UIImageView().then{
        $0.image = UIImage(named: "arrow_right_blue")
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
        self.contentView.addSubview(backView)
        
        backView.addSubview(placeNameLabel)
        backView.addSubview(dotLabel)
        backView.addSubview(placeCategoryLabel)
        backView.addSubview(distanceLabel)
        
        backView.addSubview(goLinkImageButton)
        backView.addSubview(goLinkButton)
        
        backView.addSubview(pinImage)
        backView.addSubview(locationLabel)
        backView.addSubview(phoneImage)
        backView.addSubview(phoneNumLabel)
    }
    func setUpConstraint() {
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(10)
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
        goLinkImageButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.trailing.equalToSuperview().offset(-14)
            make.centerY.equalToSuperview()
        }
        goLinkButton.snp.makeConstraints { make in
            make.trailing.equalTo(goLinkImageButton.snp.leading)
            make.centerY.equalTo(goLinkImageButton)
        }
        pinImage.snp.makeConstraints { make in
            make.width.height.equalTo(19)
            make.leading.equalToSuperview().offset(19)
            make.top.equalTo(placeNameLabel.snp.bottom).offset(14)
        }
        locationLabel.snp.makeConstraints { make in
            make.leading.equalTo(pinImage.snp.trailing).offset(10)
            make.top.equalTo(pinImage)
            make.trailing.lessThanOrEqualTo(goLinkButton.snp.leading).offset(-42)
        }
        phoneImage.snp.makeConstraints { make in
            make.width.height.equalTo(15)
            make.top.equalTo(pinImage.snp.bottom).offset(24)
            make.leading.equalTo(pinImage)
        }
        phoneNumLabel.snp.makeConstraints { make in
            make.leading.equalTo(locationLabel)
            make.centerY.equalTo(phoneImage)
        }
    }
    // MARK: 서버에서 데이터를 받아온 후 출력시킵니다.
    func setUpData(_ data: KakaoResultModel) {
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
            self.locationLabel.text = location
            if location == "" {self.locationLabel.text = "주소가 없습니다."}
        }
        if let phone = data.phone {
            self.phoneNumLabel.text = phone
            if phone == "" {self.phoneNumLabel.text = "전화번호가 없습니다."}
        }
    }
}
