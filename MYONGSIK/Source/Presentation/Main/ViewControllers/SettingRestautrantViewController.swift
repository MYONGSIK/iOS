//
//  SettingRestautrantViewController.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/04/22.
//

import UIKit
import SnapKit
import Then
import WidgetKit

// MARK: 위젯용 식당 설정 페이지
class SettingRestautrantViewController: BaseViewController {
    let restaurants = [ "생활관식당", "명진당", "학생회관", "교직원식당" ]
    var selectedResName = "생활관식당"
    
    // MARK: Views
    var restaurantsTableView: UITableView!
    
    let backButton = UIButton().then {
        $0.setImage(UIImage(named: "arrow_left_gray"), for: .normal)
        $0.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    let vcTitleLabel = UILabel().then {
        $0.text = "위젯 설정"
        $0.font = UIFont.NotoSansKR(size: 18, family: .Bold)
        $0.textColor = .black
    }
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = UserDefaults.shared.value(forKey: "yongin_widget_res_name") {}
        else { UserDefaults.shared.set("생활관식당", forKey: "yongin_widget_res_name") }
        setUpTableView(dataSourceDelegate: self)
        setupView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        restaurantsTableView.reloadData()
    }
    
    private func setUpTableView(dataSourceDelegate: UITableViewDelegate & UITableViewDataSource) {
        restaurantsTableView = UITableView()
        restaurantsTableView.then{
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.register(SettingResTableViewCell.self, forCellReuseIdentifier: "SettingResTableViewCell")
            $0.isScrollEnabled = false
            $0.backgroundColor = .white

            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.separatorStyle = .none
        }
    }
    
    private func setupView() {
        super.navigationView.addSubview(backButton)
        super.navigationView.addSubview(vcTitleLabel)
        self.view.addSubview(restaurantsTableView)
    }
    
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-23)
        }
        vcTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing).inset(-5)
            make.centerY.equalTo(backButton)
        }
        restaurantsTableView.snp.makeConstraints { make in
            make.top.equalTo(super.borderView.snp.bottom)
            make.height.equalTo(300)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SettingRestautrantViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MainViewModel.shared.getRestaurantsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingResTableViewCell", for: indexPath) as? SettingResTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.configureName(name: MainViewModel.shared.getRestaurant(index: indexPath.row).rawValue)
        
        if MainViewModel.shared.getRestaurant(index: indexPath.row).getServerName() == MainViewModel.shared.loadWidgetResName() {
            cell.setSelectedRes(selected: true)
        }else {
            cell.setSelectedRes(selected: false)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 70 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MainViewModel.shared.saveWidgetResName(resName: MainViewModel.shared.getRestaurant(index: indexPath.row).getServerName())
        WidgetCenter.shared.reloadAllTimelines()
        tableView.reloadData()
    }
}
