//
//  MainViewModel.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/07/11.
//

import Foundation
import Combine


class MainViewModel: ObservableObject{
    static let shared = MainViewModel()
    
    private let mainService = MainService()
    
    private var cancellabels: Set<AnyCancellable> = []
    
    @Published var campus: String?
    @Published var weekFood: Array<DayFoodModel> = []
    
    func weekFood(completion: @escaping (Array<DayFoodModel>) -> Void) {
        $weekFood.sink { weekFood in
            print(weekFood)
            completion(weekFood)
        }.store(in: &cancellabels)
    }
    
    func campus(completion: @escaping (String) -> Void) {
        $campus.sink { campus in
            completion(campus ?? "")
        }.store(in: &cancellabels)
    }
}


// MARK: 로직 처리
extension MainViewModel {
    func getWeekFood(area: String) {
        mainService.getWeekFood(area: area) { response in
            if response.success {
                if let data = response.data {
                    self.weekFood = data
                }
            }
        }
    }
    
    func setCampus(campus: String) {
        self.campus = campus
        
        mainService.setCampus(campus: campus)
    }
    
    
    func getCampus() {
        mainService.getCampus { campus in
            self.campus = campus
        }
    }
}
