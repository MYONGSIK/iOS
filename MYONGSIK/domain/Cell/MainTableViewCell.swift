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

//        setUpView()
//        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions
    func setUpView(data: [DayFoodModel]) {
        ALunchView = setCell(data: data[0])
        BLunchView = setCell(data: data[1])
        dinnerView = setCell(data: data[2])
        
        self.contentView.addSubview(ALunchView)
        self.contentView.addSubview(BLunchView)
        self.contentView.addSubview(dinnerView)
    }
    func setUpConstraint() {
        ALunchView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(180)
            make.leading.trailing.top.equalToSuperview().inset(21)
        }
        BLunchView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(180)
            make.leading.trailing.equalToSuperview().inset(21)
            make.top.equalTo(ALunchView.snp.bottom).offset(24)
        }
        dinnerView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(180)
            make.leading.trailing.equalToSuperview().inset(21)
            make.top.equalTo(BLunchView.snp.bottom).offset(24)
            make.bottom.equalToSuperview().offset(-26)
        }
    }
    func setCell(data: DayFoodModel) -> UIView {
        let backgroundView = UIView().then{
            $0.backgroundColor = .white
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
            $0.layer.borderColor = UIColor.borderColor.cgColor
            $0.layer.borderWidth = 1
        }
        let date = UILabel().then{
            if let date = data.toDay { $0.text = date }
            $0.font = UIFont.NotoSansKR()
            $0.textColor = .signatureGray
        }
        let dayOfTheWeek = UILabel().then{
            if let dayOfWeek = data.dayOfTheWeek {$0.text = dayOfWeek}
            $0.font = UIFont.NotoSansKR()
            $0.textColor = .signatureGray
        }
        let type = UILabel().then{
            if let type = data.classification {
                if let lunchType = data.type {$0.text = type+lunchType}
                else {$0.text = type}
            }
            $0.font = UIFont.NotoSansKR()
            $0.textColor = .signatureBlue
        }
        let foodLabel = UILabel().then{
            var foods = ""
            var food1Str = ""
            if let food1 = data.food1 {
                foods = foods + food1
                food1Str = food1
            }
            if let food2 = data.food2 {foods = foods + " " + food2}
            if let food3 = data.food3 {foods = foods + " " + food3}
            if let food4 = data.food4 {foods = foods + " " + food4}
            if let food5 = data.food5 {foods = foods + " " + food5}
            if let food6 = data.food6 {foods = foods + " " + food6}
            
            $0.text = foods
            $0.font = UIFont.NotoSansKR(size: 16, family: .Regular)
            $0.textColor = .signatureGray
            $0.numberOfLines = 0
            $0.textAlignment = .center
            
            let attribtuedString = NSMutableAttributedString(string: foods)
            let range = (foods as NSString).range(of: food1Str)
            attribtuedString.addAttribute(.foregroundColor, value: UIColor.signatureBlue, range: range)
            $0.attributedText = attribtuedString
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
            make.leading.trailing.equalToSuperview().inset(27)
            make.top.equalTo(type.snp.bottom).offset(16)
            make.bottom.equalTo(seperatorLine.snp.top).offset(-9)
        }
        thumbUpButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.equalToSuperview().offset(50)
//            make.trailing.equalTo(seperatorLine.snp.leading).offset(-48)
            make.centerY.equalTo(seperatorLine)
        }
        thumbDownButton.snp.makeConstraints { make in
            make.height.equalTo(20)
//            make.leading.equalTo(seperatorLine.snp.trailing).offset(51)
            make.trailing.equalToSuperview().offset(-50)
            make.centerY.equalTo(seperatorLine)
        }
        
        return backgroundView
    }
}
