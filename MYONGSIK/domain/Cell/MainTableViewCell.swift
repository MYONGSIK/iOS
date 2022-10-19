//
//  MainTableViewCell.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/18.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    // MARK: - Views
    let backView = UIView().then{
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.borderColor.cgColor
        $0.layer.borderWidth = 1
    }
    let date = UILabel().then{
        $0.font = UIFont.NotoSansKR()
        $0.textColor = .signatureGray
    }
    let dayOfTheWeek = UILabel().then{
        $0.font = UIFont.NotoSansKR()
        $0.textColor = .signatureGray
    }
    let type = UILabel().then{
        $0.font = UIFont.NotoSansKR()
        $0.textColor = .signatureBlue
    }
    let foodLabel = UILabel().then{
        $0.font = UIFont.NotoSansKR(size: 16, family: .Regular)
        $0.textColor = .signatureGray
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    var thumbUpButton = UIButton().then{
        // Text
        let text = NSAttributedString(string: "맛있어요")
        $0.setAttributedTitle(text, for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(size: 12, family: .Regular)
        $0.titleLabel?.textColor = .signatureGray
        // Image
        $0.setImage(UIImage(named: "thumbup"), for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
    }
    let seperatorLine = UIView().then{
        $0.backgroundColor = .seperatorColor
    }
    var thumbDownButton = UIButton().then{
        // Text
        let text = NSAttributedString(string: "맛없어요")
        $0.setAttributedTitle(text, for: .normal)
        $0.titleLabel?.font = UIFont.NotoSansKR(size: 12, family: .Regular)
        $0.titleLabel?.textColor = .signatureGray
        // Image
        $0.setImage(UIImage(named: "thumbdown"), for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
    }
    

    //MARK: - LifeCycle
    var data: DayFoodModel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUpView()
        setUpConstraint()
        
        thumbUpButton.addTarget(self, action: #selector(thumbUpButtonDidTap), for: .touchUpInside)
        thumbDownButton.addTarget(self, action: #selector(thumbDownButtonDidTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    // 맛있어요 클릭
    @objc func thumbUpButtonDidTap() {
        guard let day = data.toDay else {return}
        guard let classification = data.classification else {return}
        
        // '2022-10-19중식Agood'의 형태로 저장
        if !thumbUpButton.isSelected {
            if let type = data.type {UserDefaults.standard.set(true, forKey: day+classification+type+"good")}
            else {UserDefaults.standard.set(true, forKey: day+classification+"good")}
        }
        else {
            if let type = data.type {UserDefaults.standard.set(false, forKey: day+classification+type+"good")}
            else {UserDefaults.standard.set(false, forKey: day+classification+"good")}
        }
        setUpButtons()
    }
    // 맛없어요 클릭
    @objc func thumbDownButtonDidTap() {
        guard let day = data.toDay else {return}
        guard let classification = data.classification else {return}
        
        if !thumbDownButton.isSelected {
            if let type = data.type {UserDefaults.standard.set(true, forKey: day+classification+type+"bad")}
            else {UserDefaults.standard.set(true, forKey: day+classification+"bad")}
        }
        else {
            if let type = data.type {UserDefaults.standard.set(false, forKey: day+classification+type+"bad")}
            else {UserDefaults.standard.set(true, forKey: day+classification+"bad")}
        }
        setUpButtons()
    }
    // MARK: - Functions
    func setUpButtons() {
        guard let data = self.data else {return}
        guard let day = data.toDay else {return}
        guard let classification = data.classification else {return}
        
        if let type = data.type {
            let isGood = UserDefaults.standard.bool(forKey: day+classification+type+"good") ?? false
            thumbUpButton.isSelected = isGood
            
            let isBad = UserDefaults.standard.bool(forKey: day+classification+type+"bad") ?? false
            thumbDownButton.isSelected = isBad
        } else {
            let isGood = UserDefaults.standard.bool(forKey: day+classification+"good") ?? false
            thumbUpButton.isSelected = isGood
            
            let isBad = UserDefaults.standard.bool(forKey: day+classification+"bad") ?? false
            thumbDownButton.isSelected = isBad
        }
        
        if thumbUpButton.isSelected {thumbUpButton.titleLabel?.textColor =  .signatureBlue}
        else {thumbUpButton.titleLabel?.textColor =  .signatureGray}
        
        if thumbDownButton.isSelected {thumbDownButton.titleLabel?.textColor =  .red}
        else {thumbDownButton.titleLabel?.textColor =  .signatureGray}
        
    }
    func setUpView() {
        self.contentView.addSubview(backView)
        
        backView.addSubview(date)
        backView.addSubview(dayOfTheWeek)
        backView.addSubview(type)
        backView.addSubview(foodLabel)
        
        backView.addSubview(seperatorLine)
        backView.addSubview(thumbUpButton)
        backView.addSubview(thumbDownButton)
    }
    func setUpConstraint() {
        backView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(21)
            make.bottom.equalToSuperview()
        }
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
            make.width.equalTo(70)
            make.height.equalTo(20)
            make.leading.equalToSuperview().offset(50)
    //            make.trailing.equalTo(seperatorLine.snp.leading).offset(-48)
            make.centerY.equalTo(seperatorLine)
        }
        thumbDownButton.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(20)
    //            make.leading.equalTo(seperatorLine.snp.trailing).offset(51)
            make.trailing.equalToSuperview().offset(-50)
            make.centerY.equalTo(seperatorLine)
        }
    }
    func setUpData() {
        if let date = data.toDay { self.date.text = date }
        if let dayOfWeek = data.dayOfTheWeek {self.dayOfTheWeek.text = dayOfWeek}
        if let type = data.classification {
            if let lunchType = data.type {self.type.text = type+lunchType}
            else {self.type.text = type}
        }
        // Foods
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
        
        self.foodLabel.text = foods
        // blue string
        let attribtuedString = NSMutableAttributedString(string: foods)
        let range = (foods as NSString).range(of: food1Str)
        attribtuedString.addAttribute(.foregroundColor, value: UIColor.signatureBlue, range: range)
        self.foodLabel.attributedText = attribtuedString
    }
}
