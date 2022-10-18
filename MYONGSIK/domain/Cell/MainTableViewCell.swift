//
//  MainTableViewCell.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/18.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    // MARK: - Views

    //MARK: - LifeCycle
    var ALunchView: UIView!
    var BLunchView: UIView!
    var dinnerView: UIView!
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
        ALunchView = setCell()
        BLunchView = setCell()
        dinnerView = setCell()
        
        self.contentView.addSubview(ALunchView)
        self.contentView.addSubview(BLunchView)
        self.contentView.addSubview(dinnerView)
    }
    func setUpConstraint() {
        ALunchView.snp.makeConstraints { make in
            make.height.equalTo(180)
            make.leading.trailing.top.equalToSuperview().inset(21)
        }
        BLunchView.snp.makeConstraints { make in
            make.height.equalTo(180)
            make.leading.trailing.equalToSuperview().inset(21)
            make.top.equalTo(ALunchView.snp.bottom).offset(24)
        }
        dinnerView.snp.makeConstraints { make in
            make.height.equalTo(180)
            make.leading.trailing.equalToSuperview().inset(21)
            make.top.equalTo(BLunchView.snp.bottom).offset(24)
            make.bottom.equalToSuperview().offset(-26)
        }
    }
    func setCell() -> UIView {
        let backgroundView = UIView().then{
            $0.backgroundColor = .white
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
            $0.layer.borderColor = UIColor.borderColor.cgColor
            $0.layer.borderWidth = 1
        }
        let date = UILabel().then{
            $0.text = "2022년 10월 17일"
            $0.font = UIFont.NotoSansKR()
            $0.textColor = .signatureGray
        }
        let dayOfTheWeek = UILabel().then{
            $0.text = "월요일"
            $0.font = UIFont.NotoSansKR()
            $0.textColor = .signatureGray
        }
        let type = UILabel().then{
            $0.text = "중식A"
            $0.font = UIFont.NotoSansKR()
            $0.textColor = .signatureBlue
        }
        let foodLabel = UILabel().then{
            $0.text = "베이컨김치볶음밥&후라이 맑은우동국물 피쉬앤칩스&케찹 단무지 배추김치"
            $0.font = UIFont.NotoSansKR()
            $0.textColor = .signatureBlue
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        let thumbUpButton = UIButton().then{
            var config = UIButton.Configuration.plain()
            var attText = AttributedString.init("맛있어요")
            
            attText.font = UIFont.NotoSansKR(size: 12, family: .Regular)
            attText.foregroundColor = UIColor.signatureGray
            config.attributedTitle = attText
            
            config.image = UIImage(named: "thumbup")
            config.imagePadding = 5
            config.imagePlacement = .trailing
            
            $0.configuration = config
        }
        let seperatorLine = UIView().then{
            $0.backgroundColor = .signatureGray
        }
        let thumbDownButton = UIButton().then{
            var config = UIButton.Configuration.plain()
            var attText = AttributedString.init("맛없어요")
            
            attText.font = UIFont.NotoSansKR(size: 12, family: .Regular)
            attText.foregroundColor = UIColor.signatureGray
            config.attributedTitle = attText
            
            config.image = UIImage(named: "thumbdown")
            config.imagePadding = 5
            config.imagePlacement = .trailing
            
            $0.configuration = config
        }
        
        backgroundView.addSubview(date)
        backgroundView.addSubview(dayOfTheWeek)
        backgroundView.addSubview(type)
        backgroundView.addSubview(foodLabel)
        
        backgroundView.addSubview(seperatorLine)
        backgroundView.addSubview(thumbUpButton)
        backgroundView.addSubview(thumbDownButton)
        
        date.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.top.equalToSuperview().offset(13)
        }
        dayOfTheWeek.snp.makeConstraints { make in
            make.centerY.equalTo(date)
            make.leading.equalTo(date.snp.trailing).offset(3)
        }
        type.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-17)
            make.centerY.equalTo(date)
        }
        seperatorLine.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(1)
            make.height.equalTo(46)
            make.bottom.equalToSuperview().offset(-14)
        }
        foodLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(22)
            make.top.equalTo(type.snp.bottom).offset(16)
//            make.bottom.equalTo(seperatorLine.snp.top).offset(-9)
        }
        thumbUpButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.equalToSuperview().offset(56)
//            make.trailing.equalTo(seperatorLine.snp.leading).offset(-48)
            make.centerY.equalTo(seperatorLine)
        }
        thumbDownButton.snp.makeConstraints { make in
            make.height.equalTo(20)
//            make.leading.equalTo(seperatorLine.snp.trailing).offset(51)
            make.trailing.equalToSuperview().offset(-56)
            make.centerY.equalTo(seperatorLine)
        }
        
        return backgroundView
    }
}
