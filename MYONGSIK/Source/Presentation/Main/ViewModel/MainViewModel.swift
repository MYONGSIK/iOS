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
    
    private var selectedRestaurant: Restaurant?
    
    //안쓸거 같으면 삭제
    private var pageCount = 0
    
    @Published var campus: String?
    @Published var foodList: [[DayFoodModel]]?
    @Published var isFood: Bool = false
    
    var _pageCount: Int {
        get {
            return pageCount
        }
        set(pageCount) {
            self.pageCount = pageCount
        }
    }
    
    func campus(completion: @escaping (String) -> Void) {
        $campus.sink { campus in
            completion(campus ?? "")
        }.store(in: &cancellabels)
    }
    
    func getDayFood(day: Int, index: Int, cancelLabels: inout Set<AnyCancellable> ,completion: @escaping (DayFoodModel) -> Void) {
        $foodList.filter{ foodList in
            foodList != nil && foodList?.count != 0 && foodList?.count ?? 0 > day
        }.sink { foodList in
            completion((foodList?[day][index])!)
        }.store(in: &cancelLabels)
    }
    
    func isFood(completion: @escaping (Bool) -> Void) {
        $isFood.sink { isFood in
            completion(isFood)
        }.store(in: &cancellabels)
    }
    
    func removeFoodList() {
        isFood = false
        foodList = nil
    }
    
    func getCampus() -> String {
        return campus ?? ""
    }
    
    func getRestaurantsCount() -> Int {
        return restaurants.count
    }
    
    func getRestaurant(index: Int) -> Restaurant {
        setRestaurant(restaurant: restaurants[index])
        return restaurants[index]
    }
    
    
    func setRestaurant(restaurant: Restaurant) {
        self.selectedRestaurant = restaurant
    }
    
    func getRestaurant() -> Restaurant {
        if let restaurant = selectedRestaurant {
            return restaurant
        }
        return .academy
    }
}


// MARK: 로직 처리
extension MainViewModel {
    func getWeekFood(area: String) {
        mainService.getWeekFood(area: area) { response in
            if response.success {
                if let data = response.data {
                    self.foodList = []
                    var i = 0
                    var dayFoodList: [DayFoodModel] = []
                    data.forEach { food in
                        if i == 3 {
                            self.foodList?.append(dayFoodList)
                            
                            i = 0
                            dayFoodList.removeAll()
                        }
                        
                        dayFoodList.append(food)
                        i += 1
                    }
                    self.isFood = true
                }
            }
        }
        print(self.foodList)
    }
    
    func saveCampus(campus: String) {
        self.campus = campus
        setRestraunt()
        
        mainService.setCampus(campus: campus)
    }
    
    
    func loadCampus() {
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
