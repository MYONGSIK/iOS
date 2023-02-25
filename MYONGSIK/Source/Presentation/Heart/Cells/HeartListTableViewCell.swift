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
}

// MARK: 찜꽁리스트 셀
class HeartListTableViewCell: UITableViewCell {
    var delegate: HeartListDelegate?
    
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
        $0.text = "식당이름·"
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
    let goLinkButton = UILabel().then{
        $0.text = "바로 가기"
        $0.font = UIFont.NotoSansKR(size: 16, family: .Bold)
        $0.textColor = .signatureBlue
    }
    let goLinkImageButton = UIImageView().then{
        $0.image = UIImage(named: "arrow_right_blue")
    }
    
    let heartButton = UIButton().then {
        $0.setImage(UIImage(systemName: "heart"), for: .normal)
        $0.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        $0.tintColor = .systemPink
        $0.isSelected = true
        $0.addTarget(self, action: #selector(didTapHeartButton(_:)), for: .touchUpInside)
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
        
        backView.addSubview(placeNameLabel)
        backView.addSubview(dotLabel)
        backView.addSubview(placeCategoryLabel)
        
        backView.addSubview(goLinkImageButton)
        backView.addSubview(goLinkButton)
        backView.addSubview(heartButton)
    }
    func setUpConstraint() {
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(9)
        }
        placeNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        dotLabel.snp.makeConstraints { make in
            make.leading.equalTo(placeNameLabel.snp.trailing)
            make.centerY.equalTo(placeNameLabel)
        }
//        goLinkImageButton.snp.makeConstraints { make in
//            make.width.height.equalTo(30)
//            make.trailing.equalToSuperview().offset(-24)
//            make.centerY.equalToSuperview()
//        }
//        goLinkButton.snp.makeConstraints { make in
//            make.trailing.equalTo(goLinkImageButton.snp.leading)
//            make.centerY.equalTo(goLinkImageButton)
//        }
        heartButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(dotLabel)
        }
        placeCategoryLabel.snp.makeConstraints { make in
            make.leading.equalTo(dotLabel.snp.trailing)
            make.centerY.equalTo(dotLabel)
//            make.trailing.lessThanOrEqualTo(heartButton.snp.leading).offset(-15)
        }
        
    }
    
    func setUpData(_ data: HeartListModel) {
        if let placeName = data.placeName {self.placeNameLabel.text = placeName}
        if let category = data.category {self.placeCategoryLabel.text = category}
        if let placeUrl = data.placeUrl {self.placeUrl = placeUrl}
    }
    
    @objc func didTapHeartButton(_ sender: UIButton) {
        print("식당 좋아요 버튼 탭함")
        if let placeName = self.placeNameLabel.text {
            delegate?.deleteHeart(placeName: placeName)
        }
    }
}
