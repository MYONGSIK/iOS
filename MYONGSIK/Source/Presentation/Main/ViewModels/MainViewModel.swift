//
//  MainViewModel.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/28.
//

import UIKit
import RxSwift
import RxCocoa

enum Area: String {
    case mcc = "MCC식당"
    case staff = "교직원식당"
    case dormitry = "생활관식당"
}

final class MainViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    var area: Area?
    
    struct Input {
//        let thumbUpButtonControlEvent: ControlEvent<Void>
//        let thumbDownButtonControlEvent: ControlEvent<Void>
    }

    struct Output {
        let foodDataSubject: ReplaySubject<APIModel<[DayFoodModel]>>
    }
    
    private var dataResult: APIModel<[DayFoodModel]>!
    private let foodDataSubject = ReplaySubject<APIModel<[DayFoodModel]>>.create(bufferSize: 1)
    
    init() {
        getFoodDetailData()
    }
    
    func transform(input: Input) -> Output {
        return Output(foodDataSubject: foodDataSubject)
    }
    
    func getFoodDetailData() {
//        APIManager.shared.GetDataManager(from: Constants.BaseURL + Constants.getDayFood + "/MCC식당") { (data: APIModel<[DayFoodModel]>?, error) in
//            guard let data = data else {print("error: \(error?.debugDescription)"); return}
//            self.dataResult = data
//            self.foodDataSubject.onNext(self.dataResult!)
//        }
    }
}
