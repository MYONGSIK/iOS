//
//  MapViewModel.swift
//  MYONGSIK
//
//  Created by 유상 on 3/3/24.
//

import Foundation
import Combine

final class MapViewModel: ViewModelabel {
    private let restaurantService: RestaurantServiceProtocol
    private let heartService: HeartServiceProtocol
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellabels = Set<AnyCancellable>()
    
    init(restaurantService: RestaurantService = RestaurantService(), heartService: HeartServiceProtocol = HeartService()) {
        self.restaurantService = restaurantService
        self.heartService = heartService
    }
    
    enum Input {
        case viewDidLoad
        case tapPoi(RestaurantModel)
        case tapPhoneButton(RequestHeartModel)
        case postHeart(RequestHeartModel)
        case cancelHeart(String)
    }
    enum Output {
        case updateMap([RestaurantModel])
        case loadInfoView(RequestHeartModel, Bool, String?)
        case moveToCall(String, Bool)
        case postHeart(String)
        case cancelHeart(Bool)
    }
    
    
    func trastfrom(_ input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidLoad:
                self?.restaurantService.getRestaurantList(sort: SortType.allCases.first!.param(), completion: { result in
                    self?.output.send(.updateMap(result))
                })
            case .tapPoi(let restaurant):
                var id: String?
                var isHeart = false
                self?.heartService.getHeartList(completion: { result in
                    result.forEach {
                        if $0.name == restaurant.name {
                            isHeart = true
                            id = $0.id.description
                        }
                    }
                    
                    guard let heart = self?.transHeart(res: restaurant) else {return}
                    
                    self?.output.send(.loadInfoView(heart, isHeart, id))
                })
            case .tapPhoneButton(let heart):
                if let contact = heart.contact {
                    let url = "tel://\(contact)"
                    
                    self?.output.send(.moveToCall(url, true))
                }else {
                    self?.output.send(.moveToCall("", false))
                }
                
                break
            case .postHeart(let heart):
                self?.heartService.postHeart(heart: heart, completion: { heart in
                    self?.output.send(.postHeart(heart.id.description))
                })
                break
            case .cancelHeart(let id):
                self?.heartService.cancelHeart(id: id, completion: { result in
                    self?.output.send(.cancelHeart(result))
                })
            }
        }.store(in: &cancellabels)
        
        return output.eraseToAnyPublisher()
    }
    
    private func transHeart(res: RestaurantModel) -> RequestHeartModel {
        return RequestHeartModel(address: res.address, campus: CampusManager.shared.campus?.name, category: res.category, code: res.code, contact: res.contact, distance: res.distance, longitude: res.longitude, latitude: res.latitude, name: res.name, phoneId: DeviceIdManager.shared.getDeviceID(), urlAddress: res.urlAddress)
        
    }
}
