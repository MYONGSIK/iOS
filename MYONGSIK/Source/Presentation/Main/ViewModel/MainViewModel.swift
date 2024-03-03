//
//  MainViewModel.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/07/11.
//

import Foundation
import Combine

final class MainViewModel: ViewModelabel {
    
    private let mainService: MainServiceProtocol
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellabels = Set<AnyCancellable>()
    
    var areaList: [Area] = []
   
    
    init(mainService: MainServiceProtocol = MainService()) {
        self.mainService = mainService
        
        if CampusManager.shared.campus == .seoul {
            for i in 0..<2 {
                areaList.append(Area.allCases[i])
            }
        }else {
            for i in 2..<Area.allCases.count {
                areaList.append(Area.allCases[i])
            }
        }
    }
    
    enum Input {
        case viewDidLoad
        case tapAreaButton(Area)
        case tapSetting
    }
    
    enum Output {
        case updateArea([Area])
        case moveToArea(Area)
        case moveToSetting([Area])
    }
    
    func trastfrom(_ input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidLoad:
                self?.output.send(.updateArea(self!.areaList))
               break
            case .tapAreaButton(let area):
                self?.output.send(.moveToArea(area))
               break
            case .tapSetting:
                self?.output.send(.moveToSetting(self!.areaList))
                break
            }
        }.store(in: &cancellabels)
        
        return output.eraseToAnyPublisher()
    }
}

final class FoodViewModel: ViewModelabel {
    
    private let mainService: MainServiceProtocol
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellabels = Set<AnyCancellable>()
    
    var areaList: [Area] = []
   
    
    init(mainService: MainServiceProtocol = MainService()) {
        self.mainService = mainService
        
        if CampusManager.shared.campus == .seoul {
            for i in 0..<2 {
                areaList.append(Area.allCases[i])
            }
        }else {
            for i in 2..<Area.allCases.count {
                areaList.append(Area.allCases[i])
            }
        }
    }
    
    enum Input {
        case viewDidLoad(Area)
    }
    
    enum Output {
        case updateFood([DayFoodModel])
    }
    
    func trastfrom(_ input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidLoad(let area):
                self?.mainService.getWeekFood(area: area.getServerName(), completion: { result in
                    self?.output.send(.updateFood(result))
                })
               break
            }
        }.store(in: &cancellabels)
        
        return output.eraseToAnyPublisher()
    }
}


final class AreaSettingViewModel: ViewModelabel {
    
    private let mainService: MainServiceProtocol
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellabels = Set<AnyCancellable>()
    
    var areaList: [Area] = []
   
    init(mainService: MainServiceProtocol = MainService()) {
        self.mainService = mainService
        
        if CampusManager.shared.campus == .seoul {
            for i in 0..<2 {
                areaList.append(Area.allCases[i])
            }
        }else {
            for i in 2..<Area.allCases.count {
                areaList.append(Area.allCases[i])
            }
        }
    }
    
    enum Input {
        case viewDidLoad
        case tapAreaButton(Int)
    }
    
    enum Output {
        case loadArea([Area], Int)
        case updateArea(Bool)
    }
    
    func trastfrom(_ input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case.viewDidLoad:
                self?.mainService.getWidgetResName(completion: { result in
                    var index = 0
                    if let area = result {
                        for i in 0..<self!.areaList.count {
                            if self!.areaList[i].getServerName() == area {
                                index = i
                            }
                        }
                    }
                    self?.output.send(.loadArea(self!.areaList, index))
                })
                break
            case .tapAreaButton(let index):
                self?.mainService.setWidgetResName(resName: self!.areaList[index].getServerName())
                self?.output.send(.updateArea(true))
                break
                
            }
        }.store(in: &cancellabels)
        
        return output.eraseToAnyPublisher()
    }
}
