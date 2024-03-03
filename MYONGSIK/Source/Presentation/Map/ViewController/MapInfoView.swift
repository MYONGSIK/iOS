//
//  MapStoreViewController.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/04/16.
//

import UIKit
import Combine
import CombineCocoa
import Toast

class MapInfoView: UIView {
    
    private var heart: RequestHeartModel?
    private var isHeart: Bool = false
    private var id: String?
    
    private var cancellabels = Set<AnyCancellable>()
    private var input: PassthroughSubject<MapViewModel.Input, Never>?
    
    
    private let closeView = UIView().then {
        $0.backgroundColor = UIColor(red: 0.81, green: 0.8, blue: 0.832, alpha: 1)
        $0.layer.cornerRadius = 7
    }
    
    private let storeNameLabel = UILabel().then {
        $0.textColor = UIColor(red: 30 / 255, green: 32 / 255, blue: 34 / 255, alpha: 1)
        $0.font = UIFont.NotoSansKR(size: 20, family: .Bold)
    }
    
    private let meterLabel = UILabel().then {
        $0.textColor = UIColor(red: 10 / 255, green: 69 / 255, blue: 202 / 255, alpha: 1)
        $0.font = UIFont.NotoSansKR(size: 15, family: .Bold)
    }
    
    private let categoryLabel = UILabel().then {
        $0.textColor = UIColor(red: 131 / 255, green: 142 / 255, blue: 154 / 255, alpha: 1)
        $0.font = UIFont.NotoSansKR(size: 14, family: .Regular)
    }
    
    private let pinImageView = UIImageView().then {
        $0.image = UIImage(named: "pin")
    }
    
    private let addressLabel = UILabel().then {
        $0.textColor = UIColor(red: 131 / 255, green: 142 / 255, blue: 154 / 255, alpha: 1)
        $0.font = UIFont.NotoSansKR(size: 14, family: .Regular)
    }
    
    private let heartButton = UIButton().then {
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.borderWidth = 0.5
        
        $0.layer.cornerRadius = 15
        $0.setImage(UIImage(named: "heartButton"), for: .normal)
        $0.setImage(UIImage(named: "heartFillButton"), for: .selected)
        
        $0.layer.shadowColor = UIColor(red: 62 / 255, green: 64 / 255, blue: 74 / 255, alpha: 0.16).cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    private let phoneButton = UIButton().then {
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.borderWidth = 0.5
        
        $0.layer.cornerRadius = 15
        $0.setImage(UIImage(named: "phoneButton"), for: .normal)
        
        $0.layer.shadowColor = UIColor(red: 62 / 255, green: 64 / 255, blue: 74 / 255, alpha: 0.16).cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    func setId(id: String?) {
        self.id = id
    }
    
    
    
    func configure(heart: RequestHeartModel, isHeart: Bool, id: String?, input: PassthroughSubject<MapViewModel.Input, Never>) -> UIView {
        setUpInitialSubView()
        
        self.heart = heart
        self.input = input
        self.id = id
        
        if let name = heart.name {storeNameLabel.text = name}
        if let category = heart.category {categoryLabel.text = category}
        if let address = heart.address { addressLabel.text = address}
        
        if let distance = heart.distance {
            if let distanceInt = Int(distance){
                if distanceInt >= 1000 {
                    let distanceKmFirst = distanceInt / 1000
                    let distanceKmSecond = (distanceInt % 1000) / 100
                    meterLabel.text = "\(distanceKmFirst).\(distanceKmSecond)km"
                } else {
                    meterLabel.text = "\(distanceInt)m"
                }
            }
        }
        reloadDataAnimation(isHeart: isHeart)
        
        bind()
        
        return self
    }
    
    
    private func setUpInitialSubView() {
        self.backgroundColor = .white
        
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 40
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        
        
        self.addSubview(closeView)
        closeView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(11)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(40)
            $0.height.equalTo(5)
        }
        
        self.addSubview(storeNameLabel)
        storeNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(29)
            $0.top.equalToSuperview().offset(31)
            $0.height.equalTo(29)
        }
        
        self.addSubview(meterLabel)
        meterLabel.snp.makeConstraints {
            $0.leading.equalTo(storeNameLabel.snp.trailing).offset(11)
            $0.top.equalToSuperview().offset(39)
            $0.height.equalTo(15)
        }
        
        self.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(29)
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(1)
            $0.height.equalTo(20)
        }
        
        self.addSubview(pinImageView)
        pinImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(26)
            $0.top.equalTo(categoryLabel.snp.bottom).offset(8)
            $0.width.equalTo(19)
            $0.height.equalTo(19)
        }
        
        self.addSubview(addressLabel)
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(pinImageView.snp.trailing).offset(0)
            $0.top.equalTo(categoryLabel.snp.bottom).offset(7)
            $0.height.equalTo(20)
        }
        
        let buttonWidth = (UIScreen.main.bounds.width / 2) - 10
        
        self.addSubview(heartButton)
        heartButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.top.equalTo(addressLabel.snp.bottom).offset(12)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(48)
        }
        
        self.addSubview(phoneButton)
        phoneButton.snp.makeConstraints {
            $0.leading.equalTo(heartButton.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().inset(12)
            $0.top.equalTo(addressLabel.snp.bottom).offset(12)
            $0.height.equalTo(48)
        }
        
    }
    
    func bind() {
        heartButton.tapPublisher.sink { [weak self] _ in
            if self!.isHeart {
                self?.input?.send(.cancelHeart((self?.id)!))
            }else {
                self?.input?.send(.postHeart(self!.heart!))
            }
        }.store(in: &cancellabels)
        
        phoneButton.tapPublisher.sink { [weak self] _ in
            self?.input?.send(.tapPhoneButton(self!.heart!))
        }.store(in: &cancellabels)
    }
    
    func reloadDataAnimation(isHeart: Bool) {
        UIView.transition(with: self.heartButton,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.isHeart = isHeart
                            self.heartButton.isSelected = isHeart
                         },
                         completion: nil);
    }
    

}
