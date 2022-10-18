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
    
    // MARK: - Life Cycles
    var ALunchView: UIView!
    var BLunchView: UIView!
    var dinnerView: UIView!
    
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
        ALunchView = setUpData()
        BLunchView = setUpData()
        dinnerView = setUpData()
        
        self.backView.addSubview(date)
        self.backView.addSubview(dayOfWeek)
        
        self.backView.addSubview(ALunchView)
        self.backView.addSubview(BLunchView)
        self.backView.addSubview(dinnerView)
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
        ALunchView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(111)
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(date.snp.bottom).offset(10)
        }
        BLunchView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(111)
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(ALunchView.snp.bottom)
        }
        dinnerView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(111)
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(BLunchView.snp.bottom)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    func setUpData() -> UIView {
        let backgroundCellView = UIView()
        let typeLabel = PaddingLabel().then{
            $0.text = "중식A"
            $0.backgroundColor = .signatureBlue
            $0.font = UIFont.NotoSansKR(size: 12, family: .Regular)
            $0.textColor = .white
            
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
        }
        let foodsLabel = UILabel().then{
            $0.text = "베이컨김치볶음밥&후라이 맑은우동국물 피쉬앤칩스&케찹 단무지 배추김치"
            $0.font = UIFont.NotoSansKR(size: 16, family: .Regular)
            $0.textColor = .signatureGray
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        let seperatorLine = UIView().then{
            $0.backgroundColor = .signatureBlue
        }
        
        backgroundCellView.addSubview(typeLabel)
        backgroundCellView.addSubview(foodsLabel)
        backgroundCellView.addSubview(seperatorLine)
        
        typeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(9)
            make.top.equalToSuperview().offset(16)
        }
        foodsLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(14)
        }
        seperatorLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        return backgroundCellView
    }
    // 점선
//    func setLineDot(view: UIView, color: UIColor){
//       let borderLayer = CAShapeLayer()
//       borderLayer.strokeColor = color.cgColor
//       borderLayer.lineDashPattern = [4, 4]
//       borderLayer.frame = view.bounds
//       borderLayer.fillColor = nil
//       borderLayer.path = UIBezierPath(rect: view.bounds).cgPath
//
//       view.layer.addSublayer(borderLayer)
//   }
}
