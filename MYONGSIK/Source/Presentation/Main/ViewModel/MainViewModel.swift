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
    
    private var restaurants: [Restaurant] = []
    
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
    
    func getRestaurantsCount() -> Int {
        return restaurants.count
    }
    
    func getRestaurant(index: Int) -> Restaurant {
        return restaurants[index]
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
        setRestraunt()
        
        mainService.setCampus(campus: campus)
    }
    
    
    func getCampus() {
        mainService.getCampus { campus in
            self.campus = campus
            self.setRestraunt()
        }
    }
    
    func setRestraunt() {
        if campus == CampusInfo.seoul.name {
            var seoulRestaurants: [Restaurant] = []
            for i in 0..<2 {
                seoulRestaurants.append(Restaurant.allCases[i])
            }
            self.restaurants = seoulRestaurants
        }else if campus == CampusInfo.yongin.name {
            var yonginRestaurants: [Restaurant] = []
            for i in 2..<Restaurant.allCases.count {
                yonginRestaurants.append(Restaurant.allCases[i])
            }
            self.restaurants = yonginRestaurants
        }
    }
}
