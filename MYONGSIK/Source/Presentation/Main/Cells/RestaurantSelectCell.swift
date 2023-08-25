//
//  RestaurantSelectCell.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/08/25.
//

import UIKit
import SnapKit

class RestaurantSelectCell: UITableViewCell {
    
    private let containerView = UIView()
    private let restaurantNameLabel = UILabel()
    private let operatingTimeLabel = UILabel()
    private let intoButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    private func setup() {
        self.selectionStyle = .none
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 15
        
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 1
        
        restaurantNameLabel.font = UIFont.NotoSansKR(size: 24, family: .Bold)
        restaurantNameLabel.textColor = .signatureBlue
        
        operatingTimeLabel.font = UIFont.NotoSansKR(size: 16, family: .Regular)
        operatingTimeLabel.textColor = .black
        operatingTimeLabel.numberOfLines = 0

        intoButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        intoButton.tintColor = .signatureBlue
    }
    
    private func setupView() {
        contentView.addSubview(containerView)
        containerView.addSubview(restaurantNameLabel)
        containerView.addSubview(operatingTimeLabel)
        containerView.addSubview(intoButton)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.bottom.leading.trailing.equalToSuperview().inset(5)
            $0.height.equalTo(CGFloat.screenHeight / 6.25)
        }
        restaurantNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.equalToSuperview().offset(28)
        }
        operatingTimeLabel.snp.makeConstraints {
            $0.top.equalTo(restaurantNameLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(28)
        }
        intoButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setupContent(restaurant: Restaurant) {
        restaurantNameLabel.text = restaurant.rawValue
        operatingTimeLabel.text = restaurant.getTime()
        
        if restaurant == .myungjin {
            restaurantNameLabel.snp.makeConstraints {
                $0.top.equalToSuperview().inset(15)
            }
        }
    }
}
