//
//  SettingResTableViewCell.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/04/22.
//

import UIKit

class SettingResTableViewCell: UITableViewCell {
    var name: String?
    
    let backView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.borderColor.cgColor
        $0.layer.borderWidth = 1.5
    }
    
    let nameLabel = UILabel().then {
        $0.font = UIFont.NotoSansKR(size: 16)
        $0.textColor = .black
    }
    
    let selectedButton = UIButton().then {
        $0.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        $0.tintColor = .lightGray
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUpView()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.contentView.addSubview(backView)
        backView.addSubview(nameLabel)
        backView.addSubview(selectedButton)
    }

    private func setUpConstraint() {
        backView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(25)
            make.bottom.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        selectedButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    public func configureName(name: String) {
        self.nameLabel.text = name
    }
    
    public func setupSelectedButton(selected: Bool) {
        if selected {
            selectedButton.tintColor = .signatureBlue
        } else {
            selectedButton.tintColor = .signatureGray
        }
    }
}
