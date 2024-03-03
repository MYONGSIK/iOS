//
//  FoodInfoCell.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/08/26.
//

import UIKit
import Combine

class FoodInfoCell: UITableViewCell {
    
    var cancelLabels: Set<AnyCancellable> = []
    
    private let containerView = UIView()
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
        self.selectionStyle = .none
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1.6
        containerView.layer.borderColor = UIColor(red: 0.919, green: 0.919, blue: 0.919, alpha: 1).cgColor
        
        categoryLabel.text = "카테고"
        categoryLabel.textColor = .signatureBlue
        categoryLabel.font = UIFont.NotoSansKR(size: 12, family: .Regular)
        categoryLabel.textAlignment = .center
        
        categoryLabel.layer.borderWidth = 1.6
        categoryLabel.layer.borderColor = UIColor.signatureBlue.cgColor
        categoryLabel.layer.cornerRadius = 12
        
        
        
        foodInfoLabel.text = "모짜렐라치즈 돈가츠 맑은 우동국물 추가밥 스위트콘&그린샐러드 오이피클 배추김치"
        foodInfoLabel.font = UIFont.NotoSansKR(size: 16, family: .Bold)
        foodInfoLabel.textColor = .signatureGray
        foodInfoLabel.numberOfLines = 0
        foodInfoLabel.textAlignment = .center
    }
    
    private func setupView() {
        self.contentView.addSubview(containerView)
        containerView.addSubview(categoryLabel)
        containerView.addSubview(foodInfoLabel)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {  make in
            make.top.equalToSuperview().inset(15)
            make.bottom.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(130)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.width.equalTo(53)
            make.height.equalTo(24)
        }
        
        foodInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
            make.width.equalTo(contentView.frame.width - 20)
        }
    }
    
    func setContent(foodInfo: DayFoodModel, area: Area) {
        switch foodInfo.mealType {
        case "LUNCH_A":
            categoryLabel.text = area.getLunchAName()
        case "LUNCH_B":
            categoryLabel.text = area.getLunchBName()
        case "DINNER":
            categoryLabel.text = area.getDinnerName()
        default:
            categoryLabel.text = ""
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
    
    override func layoutSubviews() {
          super.layoutSubviews()
          contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
    }
}
