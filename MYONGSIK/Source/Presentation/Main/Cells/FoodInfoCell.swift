//
//  FoodInfoCell.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/08/26.
//

import UIKit
import SnapKit
import Combine

class FoodInfoCell: UITableViewCell {
    
    var cancelLabels: Set<AnyCancellable> = []
    
    private let categoryLabel = UILabel()
    private let foodInfoLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setup() {
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.borderWidth = 1.6
        self.contentView.layer.borderColor = UIColor(red: 0.919, green: 0.919, blue: 0.919, alpha: 1).cgColor
        
        categoryLabel.text = "카테고"
        categoryLabel.textColor = .signatureBlue
        categoryLabel.font = UIFont.NotoSansKR(size: 12, family: .Regular)
        categoryLabel.layer.borderWidth = 1.6
        categoryLabel.layer.borderColor = UIColor.signatureBlue.cgColor
        categoryLabel.layer.cornerRadius = 20
        
        
        foodInfoLabel.text = "베이컨김치볶음밥&후라이 맑은우동국물\n피쉬앤칩스&케찹 단무지 배추김치"
        foodInfoLabel.font = UIFont.NotoSansKR(size: 16, family: .Bold)
        foodInfoLabel.textColor = .signatureGray
        foodInfoLabel.numberOfLines = 0
        foodInfoLabel.textAlignment = .center
    }
    
    private func setupView() {
        self.contentView.addSubview(categoryLabel)
        self.contentView.addSubview(foodInfoLabel)
    }
    
    private func setupConstraints() {
        self.contentView.snp.makeConstraints { make in
            make.height.width.equalTo(CGFloat.screenWidth - 30)
            make.height.equalTo(113)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
        }
        
        foodInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
            make.width.equalTo(contentView.frame.width - 46)
        }
    }
    
    func setContent(foodInfo: DayFoodModel) {
        switch foodInfo.mealType {
        case "LUNCH_A":
            if MainViewModel.shared.getRestaurant() == .myungjin {
                categoryLabel.text = "백반"
            }else {
                categoryLabel.text = "중식A"
            }
        case "LUNCH_B":
            if MainViewModel.shared.getRestaurant() == .myungjin {
                categoryLabel.text = "샐러드"
            }else {
                categoryLabel.text = "중식B"
            }
        case "DINNER":
            if MainViewModel.shared.getRestaurant() == .myungjin {
                categoryLabel.text = "볶음밥"
            }else {
                categoryLabel.text = "석식"
            }
        default:
            categoryLabel.text = "식사"
        }
        
        
        var mainMenu = ""
        var restMenu = ""
        
        for i in 0..<foodInfo.meals.count {
            if i == 0 {
                mainMenu = foodInfo.meals[i]
            }else {
                restMenu +=  " " + foodInfo.meals[i]
            }
        }
        
        foodInfoLabel.attributedText =  NSMutableAttributedString()
            .blueBold(string: mainMenu, fontSize: 23)
            .grayRegular(string: restMenu, fontSize: 16)
    }
}
