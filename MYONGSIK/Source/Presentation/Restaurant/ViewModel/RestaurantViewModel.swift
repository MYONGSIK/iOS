//
//  RestaurantViewModel.swift
//  MYONGSIK
//
//  Created by 유상 on 2/26/24.
//

import Foundation
import Combine

protocol RestaurantViewModelable {
    func transRes(kakaoList: [KakaoResultModel]) -> [RestaurantModel]
    func transHeart(res: RestaurantModel) -> RequestHeartModel
}

extension RestaurantViewModelable {
    func transRes(kakaoList: [KakaoResultModel]) -> [RestaurantModel] {
        return kakaoList.map {
            RestaurantModel(address: $0.address_name, category: $0.category_group_name, code: $0.id, contact: $0.phone, distance: $0.distance, name: $0.place_name, scrapCount: 0, storeId: Int($0.id!), urlAddress: $0.place_url,longitude: $0.y, latitude: $0.x)
        }
    }
    
    func transHeart(res: RestaurantModel) -> RequestHeartModel {
        return RequestHeartModel(address: res.address, campus: CampusManager.shared.campus?.name, category: res.category, code: res.code, contact: res.contact, distance: res.distance, longitude: res.longitude, latitude: res.latitude, name: res.name, phoneId: DeviceIdManager.shared.getDeviceID(), urlAddress: res.urlAddress)
        
    }
}

final class RestaurantViewModel: ViewModelabel, RestaurantViewModelable {
    private let restaurantService: RestaurantServiceProtocol
    private let heartService: HeartServiceProtocol
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellabels = Set<AnyCancellable>()
    
    init(restaurantService: RestaurantServiceProtocol = RestaurantService(), heartService: HeartServiceProtocol = HeartService()) {
        self.restaurantService = restaurantService
        self.heartService = heartService
    }
    
    enum Input {
        case viewDidLoad(String)
        case changeCategory(String)
        case tapTagButton(String)
        case tapWebButton(RestaurantModel)
        case tapAddressButton(RestaurantModel)
        case tapPhoneButton(RestaurantModel)
    }
    
    enum Output {
        case updateRestaurant([RestaurantModel])
        case moveToTagVC(String)
        case moveToWeb(RequestHeartModel, Bool, String?)
        case moveToMap(String, Bool)
        case moveToCall(String, Bool)
    }
    
    
    
    func trastfrom(_ input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        
        input.sink { [weak self] event in
            switch event {
            case .viewDidLoad(let string), .changeCategory(let string):
                if string == "" {
                    self?.restaurantService.getKakaoRestaurantList {result in
                        self?.output.send(.updateRestaurant(self!.transRes(kakaoList: result)))
                    }
                }else {
                    self?.restaurantService.getRestaurantList(sort: string) { result in
                        self?.output.send(.updateRestaurant(result))
                    }
                }
                break
            case .tapTagButton(let tag):
                self?.output.send(.moveToTagVC(tag))
                break
            case .tapWebButton(let restaurantModel):
                guard let urlAddress = restaurantModel.urlAddress else {return}
                var id: String?
                var isHeart = false
                self?.heartService.getHeartList(completion: { result in
                    result.forEach {
                        if $0.name == restaurantModel.name {
                            isHeart = true
                            id = $0.id.description
                        }
                    }
                    
                    guard let heart = self?.transHeart(res: restaurantModel) else {return}
                    
                    self?.output.send(.moveToWeb(heart, isHeart, id))
                })
                break
            case .tapAddressButton(let restaurantModel):
                if let address = restaurantModel.address {
                    let url = "nmap://search?query=" + address
                    
                    self?.output.send(.moveToMap(url, true))
                }else {
                    self?.output.send(.moveToMap("", false))
                }
                
                break
            case .tapPhoneButton(let restaurantModel):
                if let contact = restaurantModel.contact {
                    let url = "tel://\(contact)"
                    
                    self?.output.send(.moveToCall(url, true))
                }else {
                    self?.output.send(.moveToCall("", false))
                }
                
                break
            }
        }.store(in: &cancellabels)
        
        return output.eraseToAnyPublisher()
    }
}

final class RestaurantTagViewModel: ViewModelabel, RestaurantViewModelable {
    private let restaurantService: RestaurantServiceProtocol
    private let heartService: HeartServiceProtocol
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellabels = Set<AnyCancellable>()
    
    init(restaurantService: RestaurantServiceProtocol = RestaurantService(), heartService: HeartServiceProtocol = HeartService()) {
        self.restaurantService = restaurantService
        self.heartService = heartService
    }
    
    enum Input {
        case getTagResList(String, Int)
        case tapWebButton(RestaurantModel)
        case tapAddressButton(RestaurantModel)
        case tapPhoneButton(RestaurantModel)
    }
    enum Output {
        case updateTagResList([RestaurantModel])
        case moveToWeb(RequestHeartModel, Bool, String?)
        case moveToMap(String, Bool)
        case moveToCall(String, Bool)
    }
    
    
    func trastfrom(_ input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .getTagResList(let tag, let page):
                self?.restaurantService.getTagRestaurantList(keyword: tag, page: page) { result in
                    self?.output.send(.updateTagResList(self!.transRes(kakaoList: result)))
                }
                break
            case .tapWebButton(let restaurantModel):
                guard let urlAddress = restaurantModel.urlAddress else {return}
                var id: String?
                var isHeart = false
                self?.heartService.getHeartList(completion: { result in
                    result.forEach {
                        if $0.name == restaurantModel.name {
                            isHeart = true
                            id = $0.id.description
                        }
                    }
                    
                    guard let heart = self?.transHeart(res: restaurantModel) else {return}
                    
                    self?.output.send(.moveToWeb(heart, isHeart, id))
                })
                break
            case .tapAddressButton(let restaurantModel):
                if let address = restaurantModel.address {
                    let url = "nmap://search?query=" + address
                    
                    self?.output.send(.moveToMap(url, true))
                }else {
                    self?.output.send(.moveToMap("", false))
                }
                
                break
            case .tapPhoneButton(let restaurantModel):
                if let contact = restaurantModel.contact {
                    let url = "tel://\(contact)"
                    
                    self?.output.send(.moveToCall(url, true))
                }else {
                    self?.output.send(.moveToCall("", false))
                }
                
                break
            }
        }.store(in: &cancellabels)
        
        return output.eraseToAnyPublisher()
    }
}

final class RestaurantSearchViewModel: ViewModelabel, RestaurantViewModelable {
    private let restaurantService: RestaurantServiceProtocol
    private let heartService: HeartServiceProtocol
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellabels = Set<AnyCancellable>()
    
    init(restaurantService: RestaurantServiceProtocol = RestaurantService(), heartService: HeartServiceProtocol = HeartService()) {
        self.restaurantService = restaurantService
        self.heartService = heartService
    }
    
    enum Input {
        case search(String)
        case tapWebButton(RestaurantModel)
        case tapAddressButton(RestaurantModel)
        case tapPhoneButton(RestaurantModel)
    }
    enum Output {
        case updateSearchRes([RestaurantModel])
        case moveToWeb(RequestHeartModel, Bool, String?)
        case moveToMap(String, Bool)
        case moveToCall(String, Bool)
    }
    
    
    func trastfrom(_ input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .search(let keyword):
                self?.restaurantService.getSearchRestaurantList(keyword: keyword, page: 1, completion: { result in
                    self?.output.send(.updateSearchRes(self!.transRes(kakaoList: result)))
                })
                break
            case .tapWebButton(let restaurantModel):
                guard let urlAddress = restaurantModel.urlAddress else {return}
                var id: String?
                var isHeart = false
                self?.heartService.getHeartList(completion: { result in
                    result.forEach {
                        if $0.name == restaurantModel.name {
                            isHeart = true
                            id = $0.id.description
                        }
                    }
                    
                    guard let heart = self?.transHeart(res: restaurantModel) else {return}
                    
                    self?.output.send(.moveToWeb(heart, isHeart, id))
                })
                break
            case .tapAddressButton(let restaurantModel):
                if let address = restaurantModel.address {
                    let url = "nmap://search?query=" + address
                    
                    self?.output.send(.moveToMap(url, true))
                }else {
                    self?.output.send(.moveToMap("", false))
                }
                
                break
            case .tapPhoneButton(let restaurantModel):
                if let contact = restaurantModel.contact {
                    let url = "tel://\(contact)"
                    
                    self?.output.send(.moveToCall(url, true))
                }else {
                    self?.output.send(.moveToCall("", false))
                }
                
                break
            }
        }.store(in: &cancellabels)
        
        return output.eraseToAnyPublisher()
    }
}
