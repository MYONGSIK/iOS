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
        case viewDidLoad
        case changeCategory(String)
        case selectCollect(String)
        case searchRestaurant(String)
        case tapPhone(String)
        case tapAddress(String)
        case tapLinkButton(String)
    }
    
    enum Output {
        case updateRestaurant([RestaurantModel])
        case updateKakaoRestaurant([KakaoResultModel])
        case callRestaurant(String)
        case moveNaverMap(String)
    }
    
    func trastfrom(_ input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        
        input.sink { [weak self] event in
            switch event {
            case .viewDidLoad:
//                self?.restaurantService.getRestaurantList() { result in
//                    self?.output.send(.updateRestaurant(result))
//                }
                break
            case .changeCategory(let string):
                break
            case .selectCollect(let string):
                break
            case .searchRestaurant(let string):
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
