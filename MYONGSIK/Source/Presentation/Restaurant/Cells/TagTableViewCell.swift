//
//  TagTableViewCell.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit

protocol TagCellDelegate {
    func didTapTagButton(tagKeyword: String)
}

class TagTableViewCell: UITableViewCell {

    // MARK: Life Cycles
    var delegate: TagCellDelegate?
    
    var tagContainerView: UIView!
    var mealTagButton: UIButton!
    var cafeTagButton: UIButton!
    var drinkTagButton: UIButton!
    var bakeryTagButton: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func setTagView() {
        /// set container view
        tagContainerView = UIView().then { $0.backgroundColor = .white }
        
        self.contentView.addSubview(tagContainerView)
        tagContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
        
        /// set tag button
        mealTagButton = UIButton().then {
            $0.setImage(UIImage(named: "resIcon_meal"), for: .normal)
            $0.setTitle("집밥", for: .normal)
            $0.addTarget(self, action: #selector(didTapMealTagButton), for: .touchUpInside)
        }
        
        cafeTagButton = UIButton().then {
            $0.setImage(UIImage(named: "resIcon_cafe"), for: .normal)
            $0.setTitle("카페", for: .normal)
            $0.addTarget(self, action: #selector(didTapCafeTagButton), for: .touchUpInside)
        }
        
        drinkTagButton = UIButton().then {
            $0.setImage(UIImage(named: "resIcon_drink"), for: .normal)
            $0.setTitle("술집", for: .normal)
            $0.addTarget(self, action: #selector(didTapDrinkTagButton), for: .touchUpInside)
        }
        
        bakeryTagButton = UIButton().then {
            $0.setImage(UIImage(named: "resIcon_bakery"), for: .normal)
            $0.setTitle("빵집", for: .normal)
            $0.addTarget(self, action: #selector(didTapBakeryTagButton), for: .touchUpInside)
        }
        
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
    
    @objc private func didTapMealTagButton() { delegate?.didTapTagButton(tagKeyword: "맛집") }
    @objc private func didTapCafeTagButton() { delegate?.didTapTagButton(tagKeyword: "카페") }
    @objc private func didTapDrinkTagButton() { delegate?.didTapTagButton(tagKeyword: "술집") }
    @objc private func didTapBakeryTagButton() { delegate?.didTapTagButton(tagKeyword: "빵집") }
    
}
