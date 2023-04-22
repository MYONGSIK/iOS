//
//  HeartListTableViewCell.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/02.
//

import UIKit

protocol HeartListDelegate {
    func deleteHeart(placeName: String)
    func reloadTableView()
    func moveToWebVC(link: String)
}

// MARK: 찜꽁리스트 셀
class HeartListTableViewCell: UITableViewCell {
    var delegate: HeartListDelegate?
    
    var isSelect: Bool = false
    var store: StoreModel?
    
    // MARK: - Views
    let backView = UIView().then{
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        $0.layer.shadowColor = UIColor.black.cgColor // 색깔
        $0.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        $0.layer.shadowOffset = CGSize(width: 0, height: 0) // 위치조정
        $0.layer.shadowRadius = 2 // 반경
        $0.layer.shadowOpacity = 0.2 // alpha값
    }
    let placeNameLabel = UILabel().then{
        $0.text = "식당이름"
        $0.font = UIFont.NotoSansKR(size: 20, family: .Bold)
        $0.numberOfLines = 1
        $0.setContentCompressionResistancePriority(UILayoutPriority(252), for: .horizontal)
    }
    let dotLabel = UILabel().then{
        $0.text = " · "
        $0.font = UIFont.NotoSansKR(size: 20, family: .Bold)
        $0.textColor = .placeContentColor
        $0.setContentCompressionResistancePriority(UILayoutPriority(251), for: .horizontal)
    }
    let placeCategoryLabel = UILabel().then{
        $0.text = "가게종류"
        $0.font = UIFont.NotoSansKR(size: 13, family: .Bold)
        $0.textColor = .placeContentColor
        $0.setContentCompressionResistancePriority(UILayoutPriority(251), for: .horizontal)
    }
    var goLinkButton = UIButton().then{
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
    
    let heartButton = UIButton().then {
        $0.setImage(UIImage(systemName: "heart"), for: .normal)
        $0.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        $0.tintColor = .systemPink
        $0.isSelected = true
        $0.addTarget(self, action: #selector(didTapHeartButton(_:)), for: .touchUpInside)
    }
    
    private let pinImageView = UIImageView().then {
        $0.image = UIImage(named: "pin")
    }
    
    private let addressLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "가게 위치 가게 위치 가게 위치 가게 위치"
        $0.textColor = UIColor(red: 131 / 255, green: 142 / 255, blue: 154 / 255, alpha: 1)
        $0.font = UIFont.NotoSansKR(size: 13, family: .Regular)
    }
    
    private let phoneImageView = UIImageView().then {
        $0.image = UIImage(named: "phone")
    }
    
    private let phoneNumLabel = UILabel().then {
        $0.text = "가게 전화번호"
        $0.textColor = UIColor(red: 131 / 255, green: 142 / 255, blue: 154 / 255, alpha: 1)
        $0.font = UIFont.NotoSansKR(size: 13, family: .Regular)
    }
    
    private let meterLabel = UILabel().then {
        $0.textAlignment = .center
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.text = "320m"
        $0.backgroundColor = UIColor(red: 30 / 255, green: 80 / 255, blue: 167 / 255, alpha: 1)
        $0.textColor = .white
        $0.font = UIFont.NotoSansKR(size: 10, family: .Regular)
    }
    
    
    
    

    //MARK: - LifeCycle
    var placeUrl: String!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUpView()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func setUpView() {
        self.contentView.addSubview(backView)
        
        placeNameLabel.removeFromSuperview()
        dotLabel.removeFromSuperview()
        placeCategoryLabel.removeFromSuperview()
        heartButton.removeFromSuperview()
        
        if isSelect {
            backView.addSubview(pinImageView)
            backView.addSubview(addressLabel)
            backView.addSubview(phoneImageView)
            backView.addSubview(phoneNumLabel)
            backView.addSubview(meterLabel)
            backView.addSubview(goLinkButton)
        }else {
            pinImageView.removeFromSuperview()
            addressLabel.removeFromSuperview()
            phoneImageView.removeFromSuperview()
            phoneNumLabel.removeFromSuperview()
            meterLabel.removeFromSuperview()
            goLinkButton.removeFromSuperview()
        }
        
        backView.addSubview(placeNameLabel)
        backView.addSubview(dotLabel)
        backView.addSubview(placeCategoryLabel)
        backView.addSubview(heartButton)
        
        

    }
    func setUpConstraint() {
        
        backView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(9)
            make.bottom.equalToSuperview().offset(-9)
        }

        if isSelect {
            placeNameLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(15)
                make.top.equalToSuperview().offset(22)
            }
            dotLabel.snp.makeConstraints { make in
                make.leading.equalTo(placeNameLabel.snp.trailing)
                make.centerY.equalTo(placeNameLabel)
            }
            placeCategoryLabel.snp.makeConstraints { make in
                make.leading.equalTo(dotLabel.snp.trailing)
                make.centerY.equalTo(placeNameLabel)
            }
            meterLabel.snp.makeConstraints { make in
                make.leading.equalTo(placeCategoryLabel.snp.trailing).offset(8)
                make.centerY.equalTo(placeNameLabel)
                make.width.equalTo(38)
                make.height.equalTo(20)
            }

            heartButton.snp.makeConstraints {
                $0.width.height.equalTo(30)
                $0.trailing.equalToSuperview().inset(5)
                $0.centerY.equalTo(dotLabel)
            }
    
            pinImageView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(12)
                $0.top.equalTo(placeNameLabel.snp.bottom).offset(13)
                $0.width.equalTo(19)
                $0.height.equalTo(19)
            }

            addressLabel.snp.makeConstraints {
                $0.leading.equalTo(pinImageView.snp.trailing).offset(12)
                $0.top.equalTo(placeNameLabel.snp.bottom).offset(13)
                $0.width.equalTo(156)
            }

            phoneImageView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(12)
                $0.top.equalTo(addressLabel.snp.bottom).offset(10)
                $0.width.equalTo(19)
                $0.height.equalTo(19)
            }

            phoneNumLabel.snp.makeConstraints {
                $0.leading.equalTo(phoneImageView.snp.trailing).offset(12)
                $0.top.equalTo(addressLabel.snp.bottom).offset(10)
                $0.height.equalTo(18)
            }
            
            goLinkButton.snp.makeConstraints { make in
                make.width.equalTo(100)
                make.height.equalTo(30)
                make.bottom.trailing.equalToSuperview().inset(20)
            }
        }else {
            placeNameLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(15)
                make.centerY.equalToSuperview()
            }
            dotLabel.snp.makeConstraints { make in
                make.leading.equalTo(placeNameLabel.snp.trailing)
                make.centerY.equalTo(placeNameLabel)
            }
            
            heartButton.snp.makeConstraints {
                $0.width.height.equalTo(30)
                $0.trailing.equalToSuperview().inset(5)
                $0.centerY.equalTo(dotLabel)
            }
            placeCategoryLabel.snp.makeConstraints { make in
                make.leading.equalTo(dotLabel.snp.trailing)
                make.centerY.equalTo(dotLabel)
                make.trailing.lessThanOrEqualTo(heartButton.snp.leading).offset(-15)
            }
        }
    }
    
    func setUpData(_ data: StoreModel, isSelect: Bool) {
        if let placeName = data.name {self.placeNameLabel.text = placeName}
        if let category = data.category {self.placeCategoryLabel.text = category}
        if let placeUrl = data.urlAddress {self.placeUrl = placeUrl}
        if let address = data.address {self.addressLabel.text = address}
        if let phoneNum = data.contact {self.phoneNumLabel.text = phoneNum}
        
        self.isSelect = isSelect
        self.store = data
        
        setUpView()
        setUpConstraint()
    }
    
    @objc func didTapHeartButton(_ sender: UIButton) {
        print("식당 좋아요 버튼 탭함")
        if let placeName = self.placeNameLabel.text {
            delegate?.deleteHeart(placeName: placeName)
        }
    }
    
    @objc func didTapGoLinkButton() {
        self.delegate?.moveToWebVC(link: store?.urlAddress ?? "")
    }
}
