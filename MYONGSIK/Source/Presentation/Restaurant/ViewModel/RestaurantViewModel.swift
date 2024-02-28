//
//  RestaurantViewModel.swift
//  MYONGSIK
//
//  Created by 유상 on 2/26/24.
//

import Foundation
import Combine


final class RestaurantViewModel: ViewModelabel {
    static let shared = RestaurantViewModel()
    
    private let restaurantService: RestaurantServiceProtocol
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellabels = Set<AnyCancellable>()
    
    init(restaurantService: RestaurantServiceProtocol = RestaurantService()) {
        self.restaurantService = restaurantService
    }
    
    enum Input {
        case viewDidLoad(String)
        case changeCategory(String)
        case selectCollect(String, Int)
        case scrollTableView(String, Int)
        case searchRestaurant(String, Int)
        case tapPhone(String)
        case tapAddress(String)
        case tapLinkButton(String)
    }
    
    enum Output {
        case updateRestaurant([RestaurantModel])
        case updateKakaoRestaurant([KakaoResultModel])
        case getTagRestaurant(String, [KakaoResultModel])
        case updateTagRestaurant([KakaoResultModel])
        case updateSearchRestaurant([KakaoResultModel])
        case callRestaurant(String)
        case moveNaverMap(String)
    }
    
    func trastfrom(_ input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        
        input.sink { [weak self] event in
            switch event {
            case .viewDidLoad(let string), .changeCategory(let string):
                if string == "" {
                    self?.restaurantService.getKakaoRestaurantList {result in
                        self?.output.send(.updateKakaoRestaurant(result))
                    }
                }else {
                    self?.restaurantService.getRestaurantList(sort: string) { result in
                        self?.output.send(.updateRestaurant(result))
                    }
                }
                break
            case .selectCollect(let string, let page):
                self?.restaurantService.getTagRestaurantList(keyword: string, page: page) { result in
                    self?.output.send(.getTagRestaurant(string, result))
                }
                break
            case .scrollTableView(let string, let page):
                self?.restaurantService.getTagRestaurantList(keyword: string, page: page) { result in
                    self?.output.send(.updateTagRestaurant(result))
                }
                break
            case .searchRestaurant(let string, let page):
                self?.restaurantService.getSearchRestaurantList(keyword: string, page: page, completion: { result in
                    self?.output.send(.updateSearchRestaurant(result))
                })
                break
            case .tapPhone(let string):
                break
            case .tapAddress(let string):
                break
            case .tapLinkButton(let string):
                break
            }
        }.store(in: &cancellabels)
        
        return output.eraseToAnyPublisher()
    }
}
