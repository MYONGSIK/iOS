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
    
    
    
    //안쓸거 같으면 삭제
    private var pageCount = 0
    private var resName = ""
    
    @Published var campus: String?
    @Published var foodList: [[DayFoodModel]] = []
    @Published var isFood: Bool = false
    @Published var selectedRestaurant: Restaurant?
    
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
    
    func getFoodList(completion: @escaping ([[DayFoodModel]]) -> Void) {
        $foodList.sink { foodList in
            completion(foodList)
        }.store(in: &cancellabels)
    }
    
    
    func getDayFood(day: Int, index: Int, cancelLabels: inout Set<AnyCancellable> ,completion: @escaping (DayFoodModel) -> Void) {
        $foodList.filter{ foodList in
            foodList.count != 0 && foodList.count > day && foodList[day].count > index
        }.sink { foodList in
            completion(foodList[day][index])
        }.store(in: &cancelLabels)
    }
    
    func isFood(completion: @escaping (Bool) -> Void) {
        $isFood.sink { isFood in
            completion(isFood)
        }.store(in: &cancellabels)
    }
    
    func removeFoodList() {
        isFood = false
        foodList.removeAll()
        selectedRestaurant = nil
    }
    
    func getSelectedRestaurant(completion: @escaping (Restaurant) -> Void) {
        $selectedRestaurant.filter { selectedRestaurant in
            selectedRestaurant != nil
        }.sink { selectedRestaurant in
            completion(selectedRestaurant!)
        }.store(in: &cancellabels)
    }
    
    func getSelectedRestaurantFoodCount(completion: @escaping (Int) -> Void) {
        $selectedRestaurant.filter { selectedRestaurant in
            selectedRestaurant != nil
        }.sink { selectedRestaurant in
            completion(selectedRestaurant!.getFoodInfoCount())
        }.store(in: &cancellabels)
    }
    
    func getCampus() -> String {
        return campus ?? ""
    }
    
    func getRestaurantsCount() -> Int {
        return restaurants.count
    }
    
    func getRestaurant(index: Int) -> Restaurant {
        return restaurants[index]
    }
    
    
    func setRestaurant(index: Int) {
        self.selectedRestaurant = restaurants[index]
    }
    
    func getRestaurant() -> Restaurant {
        if let restaurant = selectedRestaurant {
            return restaurant
        }
        return .academy
    }
    
    func getRestaurantFoodCount() -> Int {
        return self.selectedRestaurant?.getFoodInfoCount() ?? 2
    }
}


// MARK: 로직 처리
extension MainViewModel {
    func getWeekFood() {
        mainService.getWeekFood(area: (self.selectedRestaurant?.getServerName())!) { response in
            if response.success {
                if let data = response.data {
                    var dayFoodList: [DayFoodModel] = []
                    for i in 0..<data.count {
                        if self.selectedRestaurant! == .mcc || self.selectedRestaurant! == .myungjin {
                            if i % 3 == 0 && i != 0{
                                self.foodList.append(dayFoodList)
                                dayFoodList.removeAll()
                            }
                        }else {
                            if i % 2 == 0 && i != 0{
                                self.foodList.append(dayFoodList)
                                dayFoodList.removeAll()
                            }
                        }
                       
                        dayFoodList.append(data[i])
                    }
                    self.foodList.append(dayFoodList)
                    self.isFood = true
                }
            }
        }
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
    
    func saveWidgetResName(resName: String) {
        mainService.setWidgetResName(resName: resName)
    }
    
    func loadWidgetResName() -> String {
        mainService.getWidgetResName { resName in
            self.resName = resName
        }
        
        if resName == "" {
            if campus == "인문캠퍼스" {
                saveWidgetResName(resName: Restaurant.mcc.getServerName())
                return Restaurant.mcc.getServerName()
            }else if campus == "용인캠퍼스" {
                saveWidgetResName(resName: Restaurant.staff.getServerName())
                return Restaurant.staff.getServerName()
            }
        }
        
        return resName
    }
}
