//
//  HeartViewModel.swift
//  MYONGSIK
//
//  Created by 유상 on 2/19/24.
//

import Foundation
import Combine

final class HeartViewModel: ViewModelabel {
    static let shared = HeartViewModel()
    
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
        case tapLinkButton(String)
    }
    
    enum Output {
        case updateHeart([ResponseHeartModel])
        case heartResult(Bool)
        case moveToLink(String)
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
                    self?.output.send(.heartResult(result))
                }
                self?.heartService.getHeartList { result in
                    self?.output.send(.updateHeart(result))
                }
            case.tapLinkButton(let link):
                self?.output.send(.moveToLink(link))
            }
        }.store(in: &cancellabels)
        
        return output.eraseToAnyPublisher()
    }
}
