//
//  SearchResultTableViewCell.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    // MARK: Views
    let backView = UIView().then{
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        
        $0.layer.shadowColor = UIColor.black.cgColor // 색깔
        $0.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        $0.layer.shadowOffset = CGSize(width: 0, height: 0) // 위치조정
        $0.layer.shadowRadius = 4 // 반경
        $0.layer.shadowOpacity = 0.2 // alpha값
    }
    let placeNameLabel = UILabel().then{
        $0.text = "식당이름·"
        $0.font = UIFont.NotoSansKR(size: 20, family: .Bold)
        $0.numberOfLines = 1
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
        $0.text = "전화번호"
        $0.font = UIFont.NotoSansKR(size: 13, family: .Bold)
        $0.textColor = .placeContentColor
        $0.numberOfLines = 1
    }
    let goLinkButton = UIButton().then{
        var config = UIButton.Configuration.plain()
        var attText = AttributedString.init("바로 가기")
        
        attText.font = UIFont.NotoSansKR(size: 16, family: .Bold)
        attText.foregroundColor = UIColor.signatureBlue
        config.attributedTitle = attText
        
        $0.configuration = config
    }
    let goLinkImageButton = UIButton().then{
        $0.setImage(UIImage(named: "arrow_right_blue"), for: .normal)
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
            make.trailing.lessThanOrEqualToSuperview().offset(-10)  //
        }
        goLinkImageButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.trailing.equalToSuperview().offset(-14)
            make.centerY.equalToSuperview()
        }
        goLinkButton.snp.makeConstraints { make in
            make.trailing.equalTo(goLinkImageButton.snp.leading).offset(15)
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
    
    func setUpData(_ data: KakaoResultModel) {
//        print(data.distance)
        if let placeName = data.place_name {self.placeNameLabel.text = placeName}
        if let category = data.category_group_name {self.placeCategoryLabel.text = category}
        if let distance = data.distance {self.distanceLabel.text = distance + "m"}
        if let location  = data.address_name {self.locationLabel.text = location}
        if let phone = data.phone {self.phoneNumLabel.text = phone}
    }
}
