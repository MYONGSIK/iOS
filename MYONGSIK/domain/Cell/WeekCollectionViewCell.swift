//
//  WeekCollectionViewCell.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/19.
//

import UIKit

class WeekCollectionViewCell: UICollectionViewCell {
    static let identifier = "WeekCollectionViewCell"
    
    // MARK: - Views
    let backView = UIView().then{
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .white
        
        $0.layer.shadowColor = UIColor.black.cgColor // 색깔
        $0.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        $0.layer.shadowOffset = CGSize(width: 0, height: 0) // 위치조정
        $0.layer.shadowRadius = 8 // 반경
        $0.layer.shadowOpacity = 0.25 // alpha값
    }
    let date = UILabel().then{
        $0.font = UIFont.NotoSansKR()
        $0.textColor = .black
        $0.text = "2022년 10월 17일"
    }
    let dayOfWeek = UILabel().then{
        $0.font = UIFont.NotoSansKR()
        $0.textColor = .black
        $0.text = "월요일"
    }
    // 중식A
    let lunchALabel = PaddingLabel().then{
        $0.text = "중식A"
        $0.backgroundColor = .signatureBlue
        $0.font = UIFont.NotoSansKR(size: 12, family: .Regular)
        $0.textColor = .white
        
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    var lunchAFoodLabel = UILabel().then{
        $0.font = UIFont.NotoSansKR(size: 16, family: .Regular)
        $0.textColor = .signatureGray
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    let seperatorLine1 = UIImageView().then{
        $0.image = UIImage(named: "seperatorLine")
    }
    let lunchBLabel = PaddingLabel().then{
        $0.text = "중식B"
        $0.backgroundColor = .signatureBlue
        $0.font = UIFont.NotoSansKR(size: 12, family: .Regular)
        $0.textColor = .white
        
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    var lunchBFoodLabel = UILabel().then{
        $0.font = UIFont.NotoSansKR(size: 16, family: .Regular)
        $0.textColor = .signatureGray
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    let seperatorLine2 = UIImageView().then{
        $0.image = UIImage(named: "seperatorLine")
    }
    let dinnerLabel = PaddingLabel().then{
        $0.text = "석식"
        $0.backgroundColor = .signatureBlue
        $0.font = UIFont.NotoSansKR(size: 12, family: .Regular)
        $0.textColor = .white
        
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    var dinnerFoodLabel = UILabel().then{
        $0.font = UIFont.NotoSansKR(size: 16, family: .Regular)
        $0.textColor = .signatureGray
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setUpView()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setUpView() {
        self.contentView.addSubview(backView)
        
        self.backView.addSubview(date)
        self.backView.addSubview(dayOfWeek)
        self.backView.addSubview(lunchALabel)
        self.backView.addSubview(lunchAFoodLabel)
        self.backView.addSubview(seperatorLine1)
        self.backView.addSubview(lunchBLabel)
        self.backView.addSubview(lunchBFoodLabel)
        self.backView.addSubview(seperatorLine2)
        self.backView.addSubview(dinnerLabel)
        self.backView.addSubview(dinnerFoodLabel)
        
//        setLineDot(view: seperatorLine1, color: .signatureBlue)
//        setLineDot(view: seperatorLine2, color: .signatureBlue)
    }
    func setUpConstraint() {
        backView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.trailing.equalToSuperview().inset(25)
        }
        date.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(19)
        }
        dayOfWeek.snp.makeConstraints { make in
            make.centerY.equalTo(date)
            make.leading.equalTo(date.snp.trailing).offset(3)
        }
        lunchALabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(19)
            make.top.equalTo(date.snp.bottom).offset(29)
        }
        lunchAFoodLabel.snp.makeConstraints { make in
            make.top.equalTo(lunchALabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(25)
            make.centerX.equalToSuperview()
        }
        seperatorLine1.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(lunchAFoodLabel.snp.bottom).offset(16)
        }
        lunchBLabel.snp.makeConstraints { make in
            make.leading.equalTo(lunchALabel)
            make.top.equalTo(seperatorLine1.snp.bottom).offset(16)
        }
        lunchBFoodLabel.snp.makeConstraints { make in
            make.top.equalTo(lunchBLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(25)
            make.centerX.equalToSuperview()
        }
        seperatorLine2.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(lunchBFoodLabel.snp.bottom).offset(16)
        }
        dinnerLabel.snp.makeConstraints { make in
            make.leading.equalTo(lunchALabel)
            make.top.equalTo(seperatorLine2.snp.bottom).offset(16)
        }
        dinnerFoodLabel.snp.makeConstraints { make in
            make.top.equalTo(dinnerLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(25)
            make.centerX.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-40)
        }
    }
    func setUpData(_ data: WeekFoodModel) {
        if let date = data.toDay {self.date.text = date}
        if let dayOfWeek = data.dayOfTheWeek {self.dayOfWeek.text = dayOfWeek}
        
        if let lunchAFoods = data.lunchA {
            let foods = lunchAFoods.joined(separator: " ")
            self.lunchAFoodLabel.text = foods
            
            let food1 = lunchAFoods[0]
            let attribtuedString = NSMutableAttributedString(string: foods)
            let range = (foods as NSString).range(of: food1)
            attribtuedString.addAttribute(.foregroundColor, value: UIColor.signatureBlue, range: range)
            lunchAFoodLabel.attributedText = attribtuedString
        }
        if let lunchBFoods = data.lunchB {
            let foods = lunchBFoods.joined(separator: " ")
            self.lunchBFoodLabel.text = foods
            
            let food1 = lunchBFoods[0]
            let attribtuedString = NSMutableAttributedString(string: foods)
            let range = (foods as NSString).range(of: food1)
            attribtuedString.addAttribute(.foregroundColor, value: UIColor.signatureBlue, range: range)
            lunchBFoodLabel.attributedText = attribtuedString
        }
        if let dinnerFoods = data.dinner {
            let foods = dinnerFoods.joined(separator: " ")
            self.dinnerFoodLabel.text = foods
            
            let food1 = dinnerFoods[0]
            let attribtuedString = NSMutableAttributedString(string: foods)
            let range = (foods as NSString).range(of: food1)
            attribtuedString.addAttribute(.foregroundColor, value: UIColor.signatureBlue, range: range)
            dinnerFoodLabel.attributedText = attribtuedString
        }
        
    }
    // 점선
    func setLineDot(view: UIView, color: UIColor){
       let borderLayer = CAShapeLayer()
       borderLayer.strokeColor = color.cgColor
       borderLayer.lineDashPattern = [4, 4]
       borderLayer.frame = view.bounds
       borderLayer.fillColor = nil
       borderLayer.path = UIBezierPath(rect: view.bounds).cgPath

       view.layer.addSublayer(borderLayer)
   }
}
