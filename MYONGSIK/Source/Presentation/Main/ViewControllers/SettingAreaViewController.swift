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
import Combine
import Toast

// MARK: 위젯용 식당 설정 페이지
class SettingAreaViewController: BaseViewController {
    private let viewModel = AreaSettingViewModel()
    private var cancellabels = Set<AnyCancellable>()
    private let input: PassthroughSubject<AreaSettingViewModel.Input, Never> = .init()
    
    var areaList: [Area] = []
    var selectIndex = 0
    
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
        
        setUpTableView(dataSourceDelegate: self)
        setupView()
        setupConstraints()
        bind()
        
        input.send(.viewDidLoad)
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
    
    func bind() {
        let output = viewModel.trastfrom(input.eraseToAnyPublisher())
        
        output.receive(on: DispatchQueue.main).sink { [weak self] event in
            switch event {
            case .loadArea(let areaList, let selectIndex):
                self?.areaList = areaList
                self?.selectIndex = selectIndex
                self?.reloadDataAnimation()
                
            case .updateArea(_):
                WidgetCenter.shared.reloadAllTimelines()
                self?.reloadDataAnimation()
                self?.view.makeToast("위젯 설정 변경에 성공하였습니다!")
            }
        }.store(in: &cancellabels)
    }
    
    func reloadDataAnimation() {
        UIView.transition(with: self.restaurantsTableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
                          self.restaurantsTableView.reloadData()},
                          completion: nil);
    }
    
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SettingAreaViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingResTableViewCell", for: indexPath) as? SettingResTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.configureName(name: areaList[indexPath.row].rawValue)
        
        if indexPath.row == selectIndex {
            cell.setSelectedRes(selected: true)
        }else {
            cell.setSelectedRes(selected: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 70 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        input.send(.tapAreaButton(indexPath.row))

    }
}
