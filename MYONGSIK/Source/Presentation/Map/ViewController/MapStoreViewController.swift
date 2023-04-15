//
//  MapStoreViewController.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/04/16.
//

import UIKit
import Toast

protocol MapStoreDelegate {
    func addHeart(placeName: String, category: String, url: String)
    func removeHeart(placeName: String)
    func requestAddHeart(storeModel: StoreModel)
}


class MapStoreViewController: UIViewController {
    
    private var storeModel: StoreModel?
    private var isHeart: Bool = false
    private var delegate: MapStoreDelegate?
    
    private let storeView = UIView().then {
        $0.backgroundColor = .white
        
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.masksToBounds = true
        
        $0.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 40
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
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
        
        $0.addTarget(self, action: #selector(heartButtonTap), for: .touchUpInside)
        $0.layer.cornerRadius = 15
        $0.setImage(UIImage(named: "heartButton"), for: .normal)
        
        $0.layer.shadowColor = UIColor(red: 62 / 255, green: 64 / 255, blue: 74 / 255, alpha: 0.16).cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    private let phoneButton = UIButton().then {
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.borderWidth = 0.5
        
        $0.addTarget(self, action: #selector(phoneButtonTap), for: .touchUpInside)
        $0.layer.cornerRadius = 15
        $0.setImage(UIImage(named: "phoneButton"), for: .normal)
        
        $0.layer.shadowColor = UIColor(red: 62 / 255, green: 64 / 255, blue: 74 / 255, alpha: 0.16).cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGesture()
        setUpInitialSubView()
    }
    
    func setupGesture() {
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeDownGesture.direction = .down
        view.addGestureRecognizer(swipeDownGesture)
    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .down {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func configure(storeModel: StoreModel, isHeart: Bool, delegate: MapStoreDelegate) {
        self.storeModel = storeModel
        self.isHeart = isHeart
        self.delegate = delegate
        
        storeNameLabel.text = storeModel.name
        categoryLabel.text = storeModel.category
        addressLabel.text = storeModel.address
        
        if let distance = storeModel.distance {
            guard let distanceInt = Int(distance) else {return}
            if distanceInt >= 1000 {
                let distanceKmFirst = distanceInt / 1000
                let distanceKmSecond = (distanceInt % 1000) / 100
                meterLabel.text = "\(distanceKmFirst).\(distanceKmSecond)km"
            } else {
                meterLabel.text = "\(distanceInt)m"
            }
        }
        
        if isHeart {
            heartButton.setImage(UIImage(named: "heartFillButton"), for: .normal)
        }
        
    }
    
    
    @objc func heartButtonTap() {
        if isHeart {
            removeHeartAnimation()
            
            guard let placeName = storeModel?.name else {return}
            delegate?.removeHeart(placeName: placeName)
        }else {
            addHeartAnimation()
            guard let placeName = storeModel?.name else {return}
            guard let category = storeModel?.category else {return}
            guard let url = storeModel?.urlAddress else {return}
            
            delegate?.addHeart(placeName: placeName, category: category, url: url)
            delegate?.requestAddHeart(storeModel: storeModel!)
        }
    }
    
    @objc func phoneButtonTap() {
        if let phoneNum = storeModel?.contact {
            let url = "tel://\(phoneNum)"
            
            if let openApp = URL(string: url), UIApplication.shared.canOpenURL(openApp) {
                if #available(iOS 10.0, *) { UIApplication.shared.open(openApp, options: [:], completionHandler: nil) }
                else { UIApplication.shared.openURL(openApp) }
            }
            else { showToast(message: "번호가 등록되어있지 않습니다!") }
        }
        else { showToast(message: "번호가 등록되어있지 않습니다!") }
    }
    
    private func setUpInitialSubView() {
        self.view.backgroundColor = .clear
        
        self.view.addSubview(storeView)
        storeView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(220)
        }
        
        storeView.addSubview(closeView)
        closeView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(11)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(40)
            $0.height.equalTo(5)
        }
        
        storeView.addSubview(storeNameLabel)
        storeNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(29)
            $0.top.equalToSuperview().offset(31)
            $0.height.equalTo(29)
        }
        
        storeView.addSubview(meterLabel)
        meterLabel.snp.makeConstraints {
            $0.leading.equalTo(storeNameLabel.snp.trailing).offset(11)
            $0.top.equalToSuperview().offset(39)
            $0.height.equalTo(15)
        }
        
        storeView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(29)
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(1)
            $0.height.equalTo(20)
        }
        
        storeView.addSubview(pinImageView)
        pinImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(26)
            $0.top.equalTo(categoryLabel.snp.bottom).offset(8)
            $0.width.equalTo(19)
            $0.height.equalTo(19)
        }
        
        storeView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(pinImageView.snp.trailing).offset(0)
            $0.top.equalTo(categoryLabel.snp.bottom).offset(7)
            $0.height.equalTo(20)
        }
        
        storeView.addSubview(heartButton)
        heartButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.top.equalTo(addressLabel.snp.bottom).offset(12)
            $0.width.equalTo(181)
            $0.height.equalTo(48)
        }
        
        storeView.addSubview(phoneButton)
        phoneButton.snp.makeConstraints {
            $0.leading.equalTo(heartButton.snp.trailing).offset(6)
            $0.top.equalTo(addressLabel.snp.bottom).offset(12)
            $0.width.equalTo(181)
            $0.height.equalTo(48)
        }
        
    }
    
    
    func showToast(message: String) {
        self.view.makeToast(message, duration: 1.0, position: .center)
    }
    
    
    
        
}

extension MapStoreViewController {
    func addHeartAnimation() {
        showToast(message: "찜꽁리스트에 추가되었습니다.💙")
        UIView.transition(with: self.heartButton,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
            self.heartButton.setImage(UIImage(named: "heartFillButton"), for: .normal)},
                          completion: nil);
    }
    func removeHeartAnimation() {
        showToast(message: "찜꽁리스트에서 삭제되었습니다.🥲")
        UIView.transition(with: self.heartButton,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
            self.heartButton.setImage(UIImage(named: "heartButton"), for: .normal)},
                          completion: nil);
    }
    
    
}
