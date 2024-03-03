//
//  RestaurantMainViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/11/01.
//

import UIKit
import SnapKit
import Then
import Toast
import DropDown
import Combine

enum CellMode {
    case kakaoCell
    case rankCell
}

enum SortType: String, CaseIterable {
    case popular = "인기순 "
    case distance = "거리순 "
    case recomend = "추천순 "
    
    func param() -> String {
        switch self {
        case .popular:
            return "scrapCount,desc"
        case .distance:
            return "distance,asc"
        case .recomend:
            return ""
        }
    }
}


// MARK: '명지 맛집' 페이지
class RestaurantMainViewController: MainBaseViewController {
    private var cancellabels = Set<AnyCancellable>()
    private let input: PassthroughSubject<RestaurantViewModel.Input, Never> = .init()
    private let viewModel = RestaurantViewModel()
    
    var cellMode: CellMode = .rankCell
    var sortType: SortType = .popular
    var rankResults: [RestaurantModel] = []
    
    let sortDropDown = DropDown()
    
    lazy var refreshControl = UIRefreshControl().then {
        $0.addTarget(self, action: #selector(refreshContentView), for: .valueChanged)
    }
    let searchButton = UIButton().then{
        $0.setImage(UIImage(named: "search_white"), for: .normal)
        $0.addTarget(self, action: #selector(goSearchButtonDidTap), for: .touchUpInside)
    }
    
    let sortButton = UIButton(type: .system).then {
        $0.setTitle("인기순 ", for: .normal)
        $0.setImage(UIImage(named: "arrow_bottom"), for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.tintColor = .gray
        $0.layer.cornerRadius = 15
    }
    
    let restaurantMainTableView = UITableView().then{
        $0.backgroundColor = .white
        
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        setUpView()
        setUpConstraint()
        bind()
        
        self.input.send(.viewDidLoad(sortType.param()))
    }
    
    
    func setUpView() {
        restaurantMainTableView.delegate = self
        restaurantMainTableView.dataSource = self
        restaurantMainTableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
        restaurantMainTableView.register(TagTableViewCell.self, forCellReuseIdentifier: "TagTableViewCell")
        
        super.navigationImgView.addSubview(searchButton)
        self.view.addSubview(restaurantMainTableView)
        restaurantMainTableView.refreshControl = refreshControl
    }
    
    func setUpConstraint() {
        searchButton.snp.makeConstraints { make in
            make.width.height.equalTo(25)
            make.centerY.equalTo(topLogoImg)
            make.trailing.equalToSuperview().inset(22)
        }
        restaurantMainTableView.snp.makeConstraints { make in
            make.top.equalTo(super.navigationImgView.snp.bottom).inset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    func bind() {
        let output = viewModel.trastfrom(input.eraseToAnyPublisher())
        
        output.receive(on: DispatchQueue.main).sink { [weak self] event in
            switch event {
            case .updateRestaurant(let result):
                if self?.sortType == .recomend {
                    self?.cellMode = .kakaoCell
                }else {
                    self?.cellMode = .rankCell
                }
                self?.rankResults = result
                self?.reloadDataAnimation()
            case .moveToTagVC(let tag):
                let vc = RestaurantTagViewController()
                vc.tag = tag
                self?.navigationController?.pushViewController(vc, animated: true)
                break
            case .moveToWeb(let heart, let isHeart, let id):
                let vc = WebViewController()
                vc.heart = heart
                vc.isHeart = isHeart
                vc.id = id
                self?.navigationController?.pushViewController(vc, animated: true)
                break
            case .moveToMap(let urlStr, let isUrl):
                if isUrl {
                    let encodedStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    
                    if let url = URL(string: encodedStr), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    else { self?.view.makeToast("네이버 지도앱이 설치되어있지 않습니다!")}
                }else {
                    self?.view.makeToast("주소가 등록되어있지 않습니다!")
                }
                break
            case .moveToCall(let url, let isUrl):
                if isUrl {
                    if let openApp = URL(string: url), UIApplication.shared.canOpenURL(openApp) {
                        if #available(iOS 10.0, *) { UIApplication.shared.open(openApp, options: [:], completionHandler: nil) }
                        else { UIApplication.shared.openURL(openApp) }
                    }
                    else { self?.view.makeToast("번호가 등록되어있지 않습니다!")}
                }else {
                    self?.view.makeToast("번호가 등록되어있지 않습니다!")
                }
                break
            }
        }.store(in: &cancellabels)
    }
    

    
    func setSortButtonCell(_ cell: UITableViewCell) {
        let sortTypeList = SortType.allCases.map {
            $0.rawValue
        }
        sortDropDown.dataSource = sortTypeList
        sortDropDown.selectedTextColor = .signatureBlue
        sortDropDown.anchorView = sortButton
        sortDropDown.bottomOffset = CGPoint(x: 0, y:(sortDropDown.anchorView?.plainView.bounds.height)!)
        sortDropDown.width = 80
        sortDropDown.cellHeight = 40
        sortButton.addTarget(self, action: #selector(didTapSortButton), for: .touchUpInside)
        sortDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.sortButton.setTitle(item, for: .normal)
            //MARK: - Viewmodel input 연결 -> enum Type 활용 index활용
            self?.sortType = SortType.allCases[index]
            self?.sortButton.setTitle("\(SortType.allCases[index].rawValue) ", for: .normal)
            self!.input.send(.viewDidLoad(SortType.allCases[index].param()))
        }
        
        let titleLabel = UILabel().then {
            $0.text = "#명지인이 선택한 맛집"
            $0.numberOfLines = 2
            $0.font = UIFont.NotoSansKR(size: 22, family: .Bold)
        }
        
        cell.contentView.addSubview(titleLabel)
        cell.contentView.addSubview(sortButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5)
            $0.leading.equalToSuperview().inset(15)
        }
        
        sortButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(30)
            $0.width.equalTo(80)
        }
    }
    
    @objc func didTapSortButton() {
        sortDropDown.show()
    }
    
    @objc func goSearchButtonDidTap(_ sender: UIButton) {
        UIDevice.vibrate()
        let vc = RestaurantSearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc private func refreshContentView() {
        refreshControl.beginRefreshing()
        input.send(.viewDidLoad(sortType.param()))
        refreshControl.endRefreshing()
    }
    
    
    func reloadDataAnimation() {
        // reload data with animation
        UIView.transition(with: self.restaurantMainTableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
                          self.restaurantMainTableView.reloadData()},
                          completion: nil);
    }

}
// MARK: - TableView delegate
/*
 '#모아뒀으니 골라보세요!' 셀 하나,
 태그 CollectionView 셀 하나,
 '#명식이가 준비했습니다!' 셀 하나,
 그 아래에는 추천 맛집 결과값이 나오기 때문에 총 Tableview의 셀 개수는 count+3 입니다.
 시간이 급해 이렇게 짰고, 자유롭게 수정하시면 되겠습니다.
 */
extension RestaurantMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.rankResults.count
        return count + 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = indexPath.row
        switch tag {
        case 0:
            let cell = UITableViewCell()
            DispatchQueue.main.async {
                cell.textLabel?.text = "#명지맛집 모음!"
                cell.textLabel?.font = UIFont.NotoSansKR(size: 22, family: .Bold)
                cell.selectionStyle = .none
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TagTableViewCell", for: indexPath) as? TagTableViewCell else { return UITableViewCell() }
            DispatchQueue.main.async {
                cell.setup()
                cell.input = self.input
                cell.selectionStyle = .none
            }
            return cell
        case 2:
            let cell = UITableViewCell()
            DispatchQueue.main.async {
                cell.selectionStyle = .none
                self.setSortButtonCell(cell)
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }

            DispatchQueue.main.async {
                let itemIdx = indexPath.item - 3
                cell.mainInput = self.input
                cell.setupRestaurant(self.rankResults[itemIdx], self.cellMode)
                cell.selectionStyle = .none
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tag = indexPath.row
        switch tag {
        case 0:
            return 60
        case 1:
            return 225
        case 2:
            return 46
        default:
            switch self.cellMode {
            case .rankCell: return 200
            case .kakaoCell: return 170
            }
        }
    }
}
