//
//  HeartViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit

class HeartViewController: BaseViewController {
    let titleLabel = UILabel().then{
        $0.text = "나만의 찜꽁리스트"
        $0.font = UIFont.NotoSansKR(size: 24, family: .Bold)
        $0.textColor = .white
    }

    // MARK: Life Cycles
    var heartTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        setUpTableView(dataSourceDelegate: self)
        setUpView()
        setUpConstraint()
    }
    // MARK: Functions
    func setUpTableView(dataSourceDelegate: UITableViewDelegate & UITableViewDataSource) {
        heartTableView = UITableView()
        heartTableView.then{
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.register(HeartListTableViewCell.self, forCellReuseIdentifier: "HeartListTableViewCell")
            
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
        }
    }
    func setUpView() {
        super.navigationView.addSubview(titleLabel)
        
        self.view.addSubview(heartTableView)
    }
    func setUpConstraint() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-22)
        }
        heartTableView.snp.makeConstraints { make in
            make.top.equalTo(super.navigationView.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
// MARK: - TableView delegate
extension HeartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeartListTableViewCell", for: indexPath) as? HeartListTableViewCell else { return UITableViewCell() }
        let itemIdx = indexPath.item
//        cell.setUpData(self.searchResult[itemIdx])
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
