//
//  HeartViewModel.swift
//  MYONGSIK
//
//  Created by 유상 on 2/19/24.
//

import Foundation
import Combine

final class HeartViewModel: ViewModelabel {
    private let heartService: HeartServiceProtocol
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellabels = Set<AnyCancellable>()
    
    init(heartService: HeartServiceProtocol = HeartService()) {
        self.heartService = heartService
    }
    
    enum Input {
        case viewDidLoad
        case viewWillAppear
        case tapHeartButton(String)
        case tapLinkButton(ResponseHeartModel)
    }
    
    enum Output {
        case updateHeart([ResponseHeartModel])
        case heartResult
        case moveToLink(RequestHeartModel, String)
    }
    
    func trastfrom(_ input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidLoad, .viewWillAppear:
                self?.heartService.getHeartList { result in
                    self?.output.send(.updateHeart(result))
                }
            case .tapHeartButton(let id):
                self?.heartService.cancelHeart(id: id) { result in
                    self?.output.send(.heartResult)
                }
            case.tapLinkButton(let heart):
                self?.output.send(.moveToLink((self?.transHeart(heart: heart))!, heart.id.description))
            }
        }.store(in: &cancellabels)
        
        return output.eraseToAnyPublisher()
    }
    
    func transHeart(heart: ResponseHeartModel) -> RequestHeartModel {
        return RequestHeartModel(address: heart.address, campus: CampusManager.shared.campus?.name, category: heart.category, code: heart.code, contact: heart.contact, distance: heart.distance,longitude: heart.longitude, latitude: heart.latitude,name: heart.name, phoneId: DeviceIdManager.shared.getDeviceID(), urlAddress: heart.urlAddress)
    }
}
