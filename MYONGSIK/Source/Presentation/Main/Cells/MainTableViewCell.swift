//
//  MainTableViewCell.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/18.
//

import UIKit
import RxSwift
import RxCocoa

class MainTableViewCell: UITableViewCell {
    // MARK: - Views
    let backView = UIView().then{
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.borderColor.cgColor
        $0.layer.borderWidth = 1.5
    }
    let date = UILabel().then{
        $0.font = UIFont.NotoSansKR()
        $0.textColor = .signatureGray
    }
    let typeView = UIView().then {
        $0.layer.borderWidth = 1.4
        $0.layer.borderColor = UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1).cgColor
        $0.layer.cornerRadius = 12
    }
    let typeLabel = UILabel().then{
        $0.font = UIFont.NotoSansKR(size: 12)
        $0.textColor = UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1)
    }
    let foodLabel = UILabel().then{
        $0.font = UIFont.NotoSansKR(size: 18, family: .Regular)
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
        $0.setImage(UIImage(named: "thumbup_blue"), for: .selected)
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
        $0.setImage(UIImage(named: "thumbdown_blue"), for: .selected)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
    }
    

    //MARK: - LifeCycle
    var data: DayFoodModel!
    let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUpView()
        setUpConstraint()
        
        // Tap Event
        thumbUpButton.rx.tap
            .bind {self.thumbUpButtonDidTap()}
            .disposed(by: disposeBag)
        
        thumbDownButton.rx.tap
            .bind {self.thumbDownButtonDidTap()}
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    // '2022-10-19중식A'의 형태로 저장
    // 아무 선택 하지 않았을 시 : 0
    // 맛있어요 : 1
    // 맛없어요 : 2
    
    // 맛있어요 클릭
    @objc func thumbUpButtonDidTap() {
        guard let day = data.toDay else {return}
        guard let classification = data.classification else {return}
        
        if thumbUpButton.isSelected {
            if let type = data.type {UserDefaults.standard.set(0, forKey: day+classification+type)}
            else {UserDefaults.standard.set(0, forKey: day+classification)}
        } else {
            if let type = data.type {UserDefaults.standard.set(1, forKey: day+classification+type)}
            else {UserDefaults.standard.set(1, forKey: day+classification)}
        }
        setUpButtons()
        UIDevice.vibrate()
    }
    // 맛없어요 클릭
    @objc func thumbDownButtonDidTap() {
        guard let day = data.toDay else {return}
        guard let classification = data.classification else {return}
        
        if thumbDownButton.isSelected {
            if let type = data.type {UserDefaults.standard.set(0, forKey: day+classification+type)}
            else {UserDefaults.standard.set(0, forKey: day+classification)}
        } else {
            if let type = data.type {UserDefaults.standard.set(2, forKey: day+classification+type)}
            else {UserDefaults.standard.set(2, forKey: day+classification)}
        }
        setUpButtons()
        UIDevice.vibrate()
    }
    // MARK: - Functions
    func setUpButtons() {
        guard let data = self.data else {return}
        guard let day = data.toDay else {return}
        guard let classification = data.classification else {return}
        
        var selected = 0
        
        if let type = data.type {
            selected = UserDefaults.standard.integer(forKey: day+classification+type) ?? 0
        } else {
            selected = UserDefaults.standard.integer(forKey: day+classification) ?? 0
        }
        
        switch selected {
        case 1:
            thumbUpButton.isSelected = true
            thumbDownButton.isSelected = false
        case 2:
            thumbUpButton.isSelected = false
            thumbDownButton.isSelected = true
        default:
            thumbUpButton.isSelected = false
            thumbDownButton.isSelected = false
        }
        // 버튼 색 지정
        thumbUpButton.titleLabel?.textColor = thumbUpButton.isSelected ? .signatureBlue : .signatureGray
        thumbDownButton.titleLabel?.textColor = thumbDownButton.isSelected ? .signatureBlue : .signatureGray
        // 버튼 폰트 지정
        thumbUpButton.titleLabel?.font = thumbUpButton.isSelected ? UIFont.NotoSansKR(size: 12, family: .Bold) : UIFont.NotoSansKR(size: 12, family: .Regular)
        thumbDownButton.titleLabel?.font = thumbDownButton.isSelected ? UIFont.NotoSansKR(size: 12, family: .Bold) : UIFont.NotoSansKR(size: 12, family: .Regular)
    }
    func setUpView() {
        self.contentView.addSubview(backView)
        
        backView.addSubview(date)
        
        backView.addSubview(typeView)
        typeView.addSubview(typeLabel)
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
        typeView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(7)
            $0.width.equalTo(50)
        }
        typeLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(3)
        }
        seperatorLine.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(1)
            make.height.equalTo(46)
            make.bottom.equalToSuperview().offset(-10)
        }
        foodLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(27)
            make.top.equalTo(typeView.snp.bottom).offset(16)
            make.bottom.equalTo(seperatorLine.snp.top).offset(-9)
        }
        thumbUpButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.equalToSuperview()
            make.trailing.equalTo(seperatorLine.snp.leading)
            make.centerY.equalTo(seperatorLine)
        }
        thumbDownButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.trailing.equalToSuperview()
            make.leading.equalTo(seperatorLine.snp.trailing)
            make.centerY.equalTo(seperatorLine)
        }
    }
    func setUpData() {
        if let date = data.toDay { self.date.text = date.toDate()?.toString() }
        if let type = data.classification {
            if let lunchType = data.type {self.typeLabel.text = type+lunchType}
            else {self.typeLabel.text = type}
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
        attribtuedString.addAttribute(.font, value: UIFont.NotoSansKR(size: 18, family: .Bold), range: range)
        self.foodLabel.attributedText = attribtuedString
    }
}
