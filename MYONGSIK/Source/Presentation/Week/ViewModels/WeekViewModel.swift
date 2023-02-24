//
//  WeekViewModel.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/28.
//
import UIKit
import RxSwift
import RxCocoa

final class WeekViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        
    }

    struct Output {
        let foodDataSubject: ReplaySubject<APIModel<[WeekFoodModel]>>
    }
    
    private var dataResult: APIModel<[WeekFoodModel]>!
    private let foodDataSubject = ReplaySubject<APIModel<[WeekFoodModel]>>.create(bufferSize: 1)
    
    init() {
        getFoodDetailData()
    }
    
    func transform(input: Input) -> Output {
        return Output(foodDataSubject: foodDataSubject)
    }
    
    func getFoodDetailData() {
//        APIManager.shared.GetDataManager(from: Constants.BaseURL + Constants.getWeekFood) { (data: APIModel<[WeekFoodModel]>?, error) in
//            guard let data = data else {print("error: \(error?.debugDescription)"); return}
//            self.dataResult = data
//            self.foodDataSubject.onNext(self.dataResult!)
//        }
    }
}
