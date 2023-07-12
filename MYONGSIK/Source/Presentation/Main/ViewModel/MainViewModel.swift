//
//  MainViewModel.swift
//  MYONGSIK
//
//  Created by 유상 on 2023/07/11.
//

import Foundation
import Combine


class MainViewModel: ObservableObject{
    private var mainService = MainService()
    
    private var cancellabels: Set<AnyCancellable> = []
    
    @Published var weekFood: Array<DayFoodModel> = []
    
    func weekFood(completion: @escaping (Array<DayFoodModel>) -> Void) {
        $weekFood.sink { weekFood in
            print(weekFood)
            completion(weekFood)
        }.store(in: &cancellabels)
    }
}


// MARK: 로직 처리
extension MainViewModel {
    func getWeekFood(area: String) {
        mainService.getWeekFood(area: area) { weekFood in
            self.weekFood = weekFood
        }
    }
}
