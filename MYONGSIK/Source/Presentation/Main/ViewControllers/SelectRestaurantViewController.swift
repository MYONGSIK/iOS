//
//  SelectRestaurantViewController.swift
//  MYONGSIK
//
//  Created by 김초원 on 2023/02/21.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa


class SelectRestaurantViewController: MainBaseViewController {
    private let viewModel = MainViewModel()
    private var cancellabels = Set<AnyCancellable>()
    private let input: PassthroughSubject<MainViewModel.Input, Never> = .init()
    
    private var areaList: [Area] = []
    
    private var buttonTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupView()
        setupConstraints()
        bind()
        
        input.send(.viewDidLoad)
    }
    
    private func setup() {
        super.setCampusButton.isHidden = false
        
        buttonTableView.delegate = self
        buttonTableView.dataSource = self
        
        buttonTableView.register(RestaurantSelectCell.self, forCellReuseIdentifier: "cell")
        
        buttonTableView.rowHeight = UITableView.automaticDimension
        buttonTableView.estimatedRowHeight = UITableView.automaticDimension
        buttonTableView.separatorStyle = .none
    
    }
    
    private func setupView() {
        self.view.addSubview(buttonTableView)
    }
    
    private func setupConstraints() {
        buttonTableView.snp.makeConstraints {
            $0.top.equalTo(super.navigationImgView.snp.bottom).inset(10)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview()
        }
    }
    
    func bind() {
        let output = viewModel.trastfrom(input.eraseToAnyPublisher())
        
        output.receive(on: DispatchQueue.main).sink { [weak self] event in
            switch event {
            case .updateArea(let areaList):
                self?.areaList = areaList
                self?.buttonTableView.reloadData()
            case .moveToArea(let area):
                let mainVC = MainViewController()
                mainVC.area = area
                self?.navigationController?.pushViewController(mainVC, animated: true)
                break
            case .moveToSetting(let areaList):
                let settingVC = SettingAreaViewController()
                self?.navigationController?.pushViewController(settingVC, animated: true)
            }
        }.store(in: &cancellabels)
    }

}

extension SelectRestaurantViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RestaurantSelectCell
        
        cell.setupContent(area: areaList[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        input.send(.tapAreaButton(areaList[indexPath.row]))
    }
}
