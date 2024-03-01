//
//  RestaurantViewModel.swift
//  MYONGSIK
//
//  Created by 유상 on 2/26/24.
//

import Foundation
import Combine


final class RestaurantViewModel: ViewModelabel {
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
        case tapHeartButton(RestaurantModel)
        case tapWebButton(RestaurantModel)
        case tapAddressButton(RestaurantModel)
        case tapPhoneButton(RestaurantModel)
    }
    
    enum Output {
        case updateRestaurant([RestaurantModel])
        case moveToTagVC(String)
        case moveToWeb(RestaurantModel, String, Bool)
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

            case .tapHeartButton(_):
                break
            case .tapWebButton(let restaurantModel):
                guard let url = restaurantModel.address else {return}
                
                var isHeart = false
                self?.heartService.getHeartList(completion: { result in
                    result.forEach {
                        if $0.name == restaurantModel.name {
                            isHeart = true
                        }
                    }
                    
                    self?.output.send(.moveToWeb(restaurantModel ,url, isHeart))
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
    
    private func transRes(kakaoList: [KakaoResultModel]) -> [RestaurantModel] {
        return kakaoList.map {
            RestaurantModel(address: $0.address_name, category: $0.category_group_name, code: $0.category_group_code, contact: $0.phone, distance: $0.distance, name: $0.place_name, scrapCount: 0, storeId: Int($0.id!), urlAddress: $0.place_url,longitude: $0.x, latitude: $0.y)
        }
    }
    
    private func transHeart(res: RestaurantModel) -> RequestHeartModel {
        return RequestHeartModel(address: res.address, campus: CampusManager.shared.campus?.name, category: res.category, code: res.code, contact: res.contact, distance: res.distance, longitude: res.longitude, latitude: res.latitude, name: res.name, phoneId: DeviceIdManager.shared.getDeviceID(), urlAddress: res.urlAddress)
        
    }
}

final class RestaurantTagViewModel: ViewModelabel {
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
        case moveToWeb(RestaurantModel, String, Bool)
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
                guard let url = restaurantModel.address else {return}
                
                var isHeart = false
                self?.heartService.getHeartList(completion: { result in
                    result.forEach {
                        if $0.name == restaurantModel.name {
                            isHeart = true
                        }
                    }
                    
                    self?.output.send(.moveToWeb(restaurantModel ,url, isHeart))
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
    
    private func transRes(kakaoList: [KakaoResultModel]) -> [RestaurantModel] {
        return kakaoList.map {
            RestaurantModel(address: $0.address_name, category: $0.category_group_name, code: $0.category_group_code, contact: $0.phone, distance: $0.distance, name: $0.place_name, scrapCount: 0, storeId: Int($0.id!), urlAddress: $0.place_url,longitude: $0.x, latitude: $0.y)
        }
    }
    
    private func transHeart(res: RestaurantModel) -> RequestHeartModel {
        return RequestHeartModel(address: res.address, campus: CampusManager.shared.campus?.name, category: res.category, code: res.code, contact: res.contact, distance: res.distance, longitude: res.longitude, latitude: res.latitude, name: res.name, phoneId: DeviceIdManager.shared.getDeviceID(), urlAddress: res.urlAddress)
        
    }
}

final class RestaurantSearchViewModel: ViewModelabel {
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
        case moveToWeb(RestaurantModel, String, Bool)
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
                guard let url = restaurantModel.address else {return}
                
                var isHeart = false
                self?.heartService.getHeartList(completion: { result in
                    result.forEach {
                        if $0.name == restaurantModel.name {
                            isHeart = true
                        }
                    }
                    
                    self?.output.send(.moveToWeb(restaurantModel ,url, isHeart))
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
    
    private func transRes(kakaoList: [KakaoResultModel]) -> [RestaurantModel] {
        return kakaoList.map {
            RestaurantModel(address: $0.address_name, category: $0.category_group_name, code: $0.category_group_code, contact: $0.phone, distance: $0.distance, name: $0.place_name, scrapCount: 0, storeId: Int($0.id!), urlAddress: $0.place_url,longitude: $0.x, latitude: $0.y)
        }
    }
    
    private func transHeart(res: RestaurantModel) -> RequestHeartModel {
        return RequestHeartModel(address: res.address, campus: CampusManager.shared.campus?.name, category: res.category, code: res.code, contact: res.contact, distance: res.distance, longitude: res.longitude, latitude: res.latitude, name: res.name, phoneId: DeviceIdManager.shared.getDeviceID(), urlAddress: res.urlAddress)
        
    }
}
