//
//  HeartViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit
import Combine
import Then

// MARK: 찜꽁리스트 페이지
class HeartViewController: MainBaseViewController {
    var heartList: [ResponseHeartModel] = []
    var isSelectedCell: [Bool] = []
    private var campusInfo: CampusInfo = .yongin
    
    private var cancellabels = Set<AnyCancellable>()
    private let input: PassthroughSubject<HeartViewModel.Input, Never> = .init()
                                            

    var heartTableView = UITableView().then{
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none

        $0.rowHeight = UITableView.automaticDimension
    }
    
    let emptyLabel = UILabel().then {
        $0.text = "찜꽁리스트가 비어있어요! \n맛집을 찜꽁해 나만의 맛집 리스트를 만들어봐요!"
        $0.numberOfLines = 0
        $0.textColor = .lightGray
        $0.font = UIFont.NotoSansKR(size: 14, family: .Bold)
        $0.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        setUpView()
        setUpConstraint()
    }
    
    private func bind() {
        let output = HeartViewModel.shared.trastfrom(input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .updateHeart(let heartList):
                    self?.heartTableView.isHidden = !heartList.isEmpty
                    self?.emptyLabel.isHidden = heartList.isEmpty
                    self?.heartList = heartList
                    self?.heartTableView.reloadData()
                    break
                case.heartResult(let result):
                    break
                    
                case .moveToLink(let link):
                    self?.moveToWebVC(link: link)
                    break
                }
            }.store(in: &cancellabels)
    }

    func setUpView() {
        self.view.addSubview(emptyLabel)
        self.view.addSubview(heartTableView)
        
        self.heartTableView.delegate = self
        self.heartTableView.dataSource = self
        self.heartTableView.register(HeartListTableViewCell.self, forCellReuseIdentifier: "HeartListTableViewCell")
    }
    func setUpConstraint() {
        heartTableView.snp.makeConstraints { make in
            make.top.equalTo(super.navigationImgView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        if heartList.count == 0 {
            heartTableView.isHidden = true
            emptyLabel.isHidden = false
            
            emptyLabel.snp.makeConstraints {
                $0.centerX.centerY.equalToSuperview()
            }
        } else {
            heartTableView.isHidden = false
            emptyLabel.isHidden = true
            
            heartTableView.snp.makeConstraints { make in
                make.top.equalTo(super.navigationImgView.snp.bottom).offset(20)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
        }
    }
    
    func moveToWebVC(link: String) {
        let vc = WebViewController()
        vc.webURL = link
        vc.heartButton.isHidden = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
// MARK: - TableView delegate
extension HeartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.heartList.count
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeartListTableViewCell", for: indexPath) as? HeartListTableViewCell else { return UITableViewCell() }
        cell.input = self.input
        cell.setUpData(self.heartList[indexPath.row], isSelect: isSelectedCell[indexPath.row])
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSelectedCell[indexPath.row] {
            return 150
        }else {
            return 90
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIDevice.vibrate()
        
        isSelectedCell[indexPath.row].toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
