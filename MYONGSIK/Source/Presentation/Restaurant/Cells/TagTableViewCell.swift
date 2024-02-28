//
//  TagTableViewCell.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit
import Then
import SnapKit
import Combine
import CombineCocoa

class TagTableViewCell: UITableViewCell {
    var cancellabels = Set<AnyCancellable>()
    private var _input: PassthroughSubject<RestaurantViewModel.Input, Never>!
    
    var input: PassthroughSubject<RestaurantViewModel.Input, Never> {
        get {
            return _input
        }
        set(value) {
            _input = value
        }
    }
    
    var tagContainerView =  UIView().then { $0.backgroundColor = .white }
    var mealTagButton = UIButton().then {
        $0.setImage(UIImage(named: "resIcon_meal"), for: .normal)
        $0.setTitle("맛집", for: .normal)
    }
    var cafeTagButton = UIButton().then {
        $0.setImage(UIImage(named: "resIcon_cafe"), for: .normal)
        $0.setTitle("카페", for: .normal)
    }
    var drinkTagButton = UIButton().then {
        $0.setImage(UIImage(named: "resIcon_drink"), for: .normal)
        $0.setTitle("술집", for: .normal)
    }
    var bakeryTagButton = UIButton().then {
        $0.setImage(UIImage(named: "resIcon_bakery"), for: .normal)
        $0.setTitle("빵집", for: .normal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellabels.removeAll()
    }
    
    // MARK: - Functions
    func setup() {
        /// set container view
        self.contentView.addSubview(tagContainerView)
        [ mealTagButton, cafeTagButton, drinkTagButton, bakeryTagButton ]
            .forEach { btn in
                
                btn.setTitleColor(.gray, for: .normal)
                btn.layer.cornerRadius = 10
                btn.backgroundColor = .white
                
                btn.layer.shadowColor = UIColor.gray.cgColor
                btn.layer.masksToBounds = false
                btn.layer.shadowOffset = CGSize(width: 0, height: 0)
                btn.layer.shadowRadius = 4
                btn.layer.shadowOpacity = 0.2
                
                tagContainerView.addSubview(btn)

                btn.snp.makeConstraints { make in
                    make.width.equalToSuperview().dividedBy(2.24)
                    make.height.equalToSuperview().dividedBy(2.35)
                }
            }
        
        setupConstraints()
        bind()
    }
    
    
    func setupConstraints() {
        tagContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }

        mealTagButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.leading.equalToSuperview().offset(12)
        }
        
        cafeTagButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.trailing.equalToSuperview().inset(12)
        }
        
        drinkTagButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(7)
            make.leading.equalToSuperview().offset(12)
        }
        
        bakeryTagButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(7)
            make.trailing.equalToSuperview().inset(12)
        }
    }
    
    func bind() {
        mealTagButton.tapPublisher.sink { [weak self] _ in
            self?.input.send(.selectCollect("맛집", 1))
        }.store(in: &cancellabels)
        
        cafeTagButton.tapPublisher.sink { [weak self] _ in
            self?.input.send(.selectCollect("카페", 1))
        }.store(in: &cancellabels)
        
        drinkTagButton.tapPublisher.sink { [weak self] _ in
            self?.input.send(.selectCollect("술집", 1))
        }.store(in: &cancellabels)
        
        bakeryTagButton.tapPublisher.sink { [weak self] _ in
            self?.input.send(.selectCollect("빵집", 1))
        }.store(in: &cancellabels)
        
    }
}
