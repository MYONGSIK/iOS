//
//  MainTableViewCell.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/18.
//

import UIKit

class MainTableViewCell: UITableViewCell {
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
        
        $0.addTarget(self, action: #selector(thumbUpButtonDidTap), for: .touchUpInside)
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
        
        $0.addTarget(self, action: #selector(thumbDownButtonDidTap), for: .touchUpInside)
    }
    

    //MARK: - LifeCycle
    var data: DayFoodModel!
//    let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUpView()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    // '2022-10-19중식A'의 형태로 저장
    // 아무 선택 하지 않았을 시 : 0
    // 맛있어요 : 1
    // 맛없어요 : 2
    
    private func showThumbPopupView(emphasisText: String) {
        let alertViewController = ThumbButtonSetPopupViewController()
        
        alertViewController.emphasisText = emphasisText
        alertViewController.fullText = "로 \n학식 평가를 하시겠어요?"
        
        alertViewController.data = self.data
        alertViewController.thumbUpButton = self.thumbUpButton
        alertViewController.thumbDownButton = self.thumbDownButton
        
        alertViewController.modalPresentationStyle = .overCurrentContext
        if let vc = self.next(ofType: UIViewController.self) { vc.present(alertViewController, animated: true) }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        if let vc = self.next(ofType: UIViewController.self) { vc.present(alert, animated: true) }
    }
    
    // 맛있어요 클릭
    @objc func thumbUpButtonDidTap() {
        if !isToday || isWeekend { showAlert(message: "당일 학식 정보에 대해서만 평가 가능"); return }
        
        guard let day = data.toDay else {return}
        guard let type = data.mealType else {return}
        
        if thumbUpButton.isSelected {
            UserDefaults.standard.set(0, forKey: day+type)
            minusEvaluationFood(evaluation: EvaluationType.love.rawValue)

        } else {
            showThumbPopupView(emphasisText: (thumbUpButton.titleLabel)!.text!)
        }
        setUpButtons()
    }
    // 맛없어요 클릭
    @objc func thumbDownButtonDidTap() {
        if !isToday || isWeekend { showAlert(message: "당일 학식 정보에 대해서만 평가 가능"); return }

        guard let day = data.toDay else {return}
        guard let type = data.mealType else {return}
        
        if thumbDownButton.isSelected {
            UserDefaults.standard.set(0, forKey: day+type)
            minusEvaluationFood(evaluation: EvaluationType.hate.rawValue)

        } else {
            showThumbPopupView(emphasisText: (thumbDownButton.titleLabel)!.text!)
        }
        setUpButtons()
    }
    
    // MARK: - Functions
    private func minusEvaluationFood(evaluation: String) {
        let param = MindFoolRequestModel(calculation: Calculation.minus.rawValue,
                                         mealEvaluate: evaluation,
                                         mealId: data.mealId)
        APIManager.shared.postData(urlEndpointString: Constants.postFoodEvaluate,
                                   dataType: MindFoolRequestModel.self,
                                   responseType: Bool.self,
                                   parameter: param,
                                   completionHandler: { result in
            print("학식 평가 취소 요청 - \(result.message)")
            
        })
    }
    
    func setUpButtons() {
        guard let data = self.data else {return}
        guard let day = data.toDay else {return}
        guard let type = data.mealType else {return}
        
        var selected = 0
        
        if let type = data.mealType {
            selected = UserDefaults.standard.integer(forKey: day+type) ?? 0
        } else {
            selected = UserDefaults.standard.integer(forKey: day+type) ?? 0
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
//        date.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(14)
//            make.top.equalToSuperview().offset(13)
//        }
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

        if let type = data.mealType {
            switch type {
            case MealType.lunch_a.rawValue: self.typeLabel.text = "중식A"
            case MealType.lunch_b.rawValue: self.typeLabel.text = "중식B"
            case MealType.dinner.rawValue: self.typeLabel.text = "석식"
            default: self.typeLabel.text = "??"
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
