//
//  WebViewModel.swift
//  MYONGSIK
//
//  Created by 유상 on 3/2/24.
//

import Foundation
import Combine

final class WebViewModel: ViewModelabel {
    private let heartService: HeartServiceProtocol
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellabels = Set<AnyCancellable>()
    
    init( heartService: HeartServiceProtocol = HeartService()) {
        self.heartService = heartService
    }
    
    enum Input {
        case viewDidLoad(RequestHeartModel)
        case postHeart(RequestHeartModel)
        case cancelHeart(String)
    }
    enum Output {
        case updateWeb(String)
        case postHeart(String)
        case cancelHeart(Bool)
    }
    
    
    func trastfrom(_ input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidLoad(let heart):
                self?.output.send(.updateWeb(heart.urlAddress!))
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
}
