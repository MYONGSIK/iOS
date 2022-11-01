//
//  HeartListTableViewCell.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/02.
//

import UIKit

class HeartListTableViewCell: UITableViewCell {
    // MARK: - Views
    let backView = UIView().then{
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        
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

    //MARK: - LifeCycle
    var data: HeartListModel!
    
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
    }
    func setUpConstraint() {
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(9)
        }
        placeNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(23)
            make.centerY.equalToSuperview()
        }
        dotLabel.snp.makeConstraints { make in
            make.leading.equalTo(placeNameLabel.snp.trailing)
            make.centerY.equalTo(placeNameLabel)
        }
        goLinkImageButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.trailing.equalToSuperview().offset(-24)
            make.centerY.equalToSuperview()
        }
        goLinkButton.snp.makeConstraints { make in
            make.trailing.equalTo(goLinkImageButton.snp.leading).offset(15)
            make.centerY.equalTo(goLinkImageButton)
        }
        placeCategoryLabel.snp.makeConstraints { make in
            make.leading.equalTo(dotLabel.snp.trailing)
            make.centerY.equalTo(dotLabel)
            make.trailing.lessThanOrEqualTo(goLinkButton.snp.leading).offset(-15)
        }
    }
}
