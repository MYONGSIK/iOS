//
//  ViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/18.
//

import UIKit
import SnapKit
import Then

class MainViewController: UIViewController {
    // MARK: - Views
    let navigationView = UIView().then{
        $0.backgroundColor = .signatureBlue
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 32
    }
    let logoImage = UIImageView().then{
        $0.image = UIImage(named: "logo")
    }
    let leftIcon = UIButton().then{
        $0.setImage(UIImage(named: "calendar"), for: .normal)
    }
    let titleLabel = UILabel().then{
        $0.text = "오늘의 식단"
        $0.font = UIFont.NotoSansKR(size: 18, family: .Bold)
    }
    let checkWeekButton = UIButton().then{
        var config = UIButton.Configuration.tinted()
        var attText = AttributedString.init("이번 주  식단 확인하기")
        
        attText.font = UIFont.NotoSansKR(size: 14, family: .Regular)
        attText.foregroundColor = UIColor.black
        config.attributedTitle = attText
        config.background.backgroundColor = .white
        config.cornerStyle = .capsule
        
        $0.configuration = config
        $0.clipsToBounds = true
        
        $0.layer.shadowColor = UIColor.black.cgColor // 색깔
        $0.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        $0.layer.shadowOffset = CGSize(width: 0, height: 0) // 위치조정
        $0.layer.shadowRadius = 2 // 반경
        $0.layer.shadowOpacity = 0.25 // alpha값
    }

    // MARK: - Life Cycles
    var mainTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView(dataSourceDelegate: self)
        setUpView()
        setUpConstraint()
    }

    // MARK: - Functions
    func setUpTableView(dataSourceDelegate: UITableViewDelegate & UITableViewDataSource) {
        mainTableView = UITableView()
        mainTableView.then{
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
            
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.separatorStyle = .none
        }
    }
    func setUpView() {
        self.view.addSubview(navigationView)
        navigationView.addSubview(logoImage)
        navigationView.addSubview(leftIcon)
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(mainTableView)
        self.view.addSubview(checkWeekButton)
    }
    func setUpConstraint() {
        navigationView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(144)
        }
        logoImage.snp.makeConstraints { make in
            make.width.equalTo(103)
            make.height.equalTo(78)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        leftIcon.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.leading.equalToSuperview().offset(22)
            make.centerY.equalTo(logoImage)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(38)
            make.centerX.equalToSuperview()
        }
        checkWeekButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(69)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-57)
            make.centerX.equalToSuperview()
        }
        mainTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.bottom.equalTo(checkWeekButton.snp.top).offset(-10)
        }
    }
}

// MARK: - TableView delegate
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
