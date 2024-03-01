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
        case tapTagButton(String, Int)
        case scrollTableView(String, Int)
        case tapHeartButton(RestaurantModel)
        case tapPhone(String)
        case tapAddress(String)
        case tapLinkButton(String)
    }
    
    enum Output {
        case updateRestaurant([RestaurantModel])
        case getTagRestaurant(String, [RestaurantModel])
        case updateTagRestaurant([RestaurantModel])
        case callRestaurant(String)
        case moveNaverMap(String)
        case heartResult(Bool)
    }
    
    private func transRes(kakaoList: [KakaoResultModel]) -> [RestaurantModel] {
        return kakaoList.map {
            RestaurantModel(address: $0.address_name, category: $0.category_group_name, code: $0.category_group_code, contact: $0.phone, distance: $0.distance, name: $0.place_name, scrapCount: 0, storeId: Int($0.id!), urlAddress: $0.place_url,longitude: $0.x, latitude: $0.y)
        }
    }
    
    
    private func transHeart(res: RestaurantModel) -> RequestHeartModel {
        return RequestHeartModel(address: res.address, campus: CampusManager.shared.campus?.name, category: res.category, code: res.code, contact: res.contact, distance: res.distance, longitude: res.longitude, latitude: res.latitude, name: res.name, phoneId: DeviceIdManager.shared.getDeviceID(), urlAddress: res.urlAddress)
        
    }
    
    private func transHeart(res: KakaoResultModel) -> RequestHeartModel {
        return RequestHeartModel(address: res.address_name, campus: CampusManager.shared.campus?.name, category: res.category_name, code: res.category_group_code, distance: res.distance, longitude: res.x ,latitude: res.y, name: res.place_name, phoneId: DeviceIdManager.shared.getDeviceID(), urlAddress: res.place_url)
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
            case .tapTagButton(let string, let page):
                self?.restaurantService.getTagRestaurantList(keyword: string, page: page) { result in
                    self?.output.send(.getTagRestaurant(string, self!.transRes(kakaoList: result)))
                }
                break
            case .scrollTableView(let string, let page):
                self?.restaurantService.getTagRestaurantList(keyword: string, page: page) { result in
                    self?.output.send(.updateTagRestaurant(self!.transRes(kakaoList: result)))
                }
                break
            case .tapPhone(let string):
                break
            case .tapAddress(let string):
                break
            case .tapLinkButton(let string):
                break
            case .tapHeartButton(_):
                break
            }
        }.store(in: &cancellabels)
        
        return output.eraseToAnyPublisher()
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
        case moveToWeb(String, Bool)
        case moveToMap(String)
        case moveToCall(String)
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
                break
            case .tapAddressButton(let restaurantModel):
                break
            case .tapPhoneButton(let restaurantModel):
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
}
