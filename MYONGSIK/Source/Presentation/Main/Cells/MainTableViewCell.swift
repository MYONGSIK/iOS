//
//  MainTableViewCell.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/18.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    var selectedRestaurant: String?
    var isToday: Bool = true
    var isWeekend: Bool = false
    
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
    
    

    //MARK: - LifeCycle
    var data: DayFoodModel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUpView()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkIsToday(isToday: Bool) {
        self.isToday = isToday
    }


    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        if let vc = self.next(ofType: UIViewController.self) { vc.present(alert, animated: true) }
    }
    
    
    
    // MARK: - Functions
    
    func setUpButtons() {
        // 명진당 식당일 경우, 맛있어요/맛없어요 버튼 삭제 및 레이아웃 재정의 필요
        if let res = selectedRestaurant {
            if res == YonginRestaurant.myungjin.rawValue {

                foodLabel.snp.makeConstraints {
                    $0.bottom.equalToSuperview().offset(-30)
                }
            }
        }
        
        guard let data = self.data else {return}
        guard let day = data.toDay else {return}
        guard let type = data.mealType else {return}
        guard let id = data.mealId else {return}
        
        var selected = 0
        
        if let type = data.mealType {
            selected = UserDefaults.standard.integer(forKey: day+type+String(id)) ?? 0
        } else {
            selected = UserDefaults.standard.integer(forKey: day+type+String(id)) ?? 0
        }
        
    }
    func setUpView() {
        self.contentView.addSubview(backView)
        
        backView.addSubview(date)
        
        backView.addSubview(typeView)
        typeView.addSubview(typeLabel)
        backView.addSubview(foodLabel)
        
    }
    func setUpConstraint() {
        backView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(21)
            make.bottom.equalToSuperview()
        }
        typeView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(7)
            $0.width.equalTo(50)
        }
        typeLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(3)
        }
        foodLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(27)
            make.top.equalTo(typeView.snp.bottom).offset(16)
            make.bottom.equalToSuperview().inset(25)
        }
    }
    func setUpData() {
        if let date = data.toDay { self.date.text = date.toDate()?.toString() }

        if let res = selectedRestaurant,
           let type = data.mealType {
            
            switch res {
            case SeoulRestaurant.mcc.rawValue:
                // 중식A - 중식B - 석식
                switch type {
                case MealType.lunch_a.rawValue: self.typeLabel.text = "중식A"
                case MealType.lunch_b.rawValue: self.typeLabel.text = "중식B"
                case MealType.dinner.rawValue: self.typeLabel.text = "석식"
                default: self.typeLabel.text = "??"
                }
            case YonginRestaurant.staff.rawValue,
                 YonginRestaurant.dormitory.rawValue:
                switch type {
                case MealType.lunch_a.rawValue: self.typeLabel.text = "중식"
                case MealType.lunch_b.rawValue: self.typeLabel.text = "중식"
                case MealType.dinner.rawValue: self.typeLabel.text = "석식"
                default: self.typeLabel.text = "??"
                }
            case YonginRestaurant.academy.rawValue:
                // 조식 - 중식
                switch type {
                case MealType.lunch_a.rawValue: self.typeLabel.text = "조식"
                case MealType.lunch_b.rawValue: self.typeLabel.text = "조식"
                case MealType.dinner.rawValue: self.typeLabel.text = "중식"
                default: self.typeLabel.text = "??"
                }
            case YonginRestaurant.myungjin.rawValue:
                // 백반 - 샐러드 - 볶음밥
                switch type {
                case MealType.lunch_a.rawValue: self.typeLabel.text = "백반"
                case MealType.lunch_b.rawValue: self.typeLabel.text = "샐러드"
                case MealType.dinner.rawValue: self.typeLabel.text = "볶음밥"
                default: self.typeLabel.text = "??"
                }
            default:
                return
            }
        }
        // Foods
        var foods = ""
        data.meals?.forEach { foods += " " + $0 }

        // blue string
        if let originStr = data.meals?[0] {
            let attribtuedString = NSMutableAttributedString(string: foods)
            let range = (foods as NSString).range(of: originStr)
            attribtuedString.addAttribute(.foregroundColor, value: UIColor.signatureBlue, range: range)
            attribtuedString.addAttribute(.font, value: UIFont.NotoSansKR(size: 18, family: .Bold), range: range)
            self.foodLabel.attributedText = attribtuedString
        } else {  self.foodLabel.text = foods }

    }
}
