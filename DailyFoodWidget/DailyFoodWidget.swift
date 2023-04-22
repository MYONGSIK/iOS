//
//  DailyFoodWidget.swift
//  DailyFoodWidget
//
//  Created by 김초원 on 2023/04/12.
//

import WidgetKit
import SwiftUI

// MARK: Constants
struct OperatingTimeStr {
    /// MCC 식당
    static let mccLanch = "중식 운영 시간 11:30~14:00"
    static let mccDinner = "석식 운영 시간 17:30~19:00"
    /// 교직원 식당
    static let staffLanch = "중식 운영 시간 11:30~13:30"
    static let staffDinner = "석식 운영 시간 17:30~18:30"
    /// 생활관 식당
    static let dormitoryLanch = "중식 운영 시간 11:30~13:30"
    static let dormitoryDinner = "석식 운영 시간 17:00~18:30"
    /// 학관 식당
    static let studentLanch = "조식 운영 시간 08:30~09:30"
    static let studentDinner = "중식 운영 시간 10:00~15:00"
    /// 명진당 식당
    static let myounginLanch = "백반 운영 시간 11:30~14:30"
    static let myounginDinner = "샐러드/볶음밥 운영 시간 10:00~15:00"
}


// MARK: api 통신을 위한 구조체 및 전역 상수 추가
struct WidgetAPIModel: Decodable {
    let success: Bool?
    let httpCode: Int?
    let localDateTime: String?
    let httpStatus: String?
    let message: String?
    var data: [DayFoodModel]?
}

struct DayFoodModel: Decodable {
    let mealId: Int?
    let mealType: String?
    let meals: [String]?
    let statusType: String?
    let toDay: String?
}

let baseURL = "http://43.201.72.185:8085/api/v2/meals/"

// MARK: 위젯을 새로고침할 타임라인을 결정하는 객체
struct Provider: IntentTimelineProvider {
    func getSnapshot(for configuration: RestaurantListIntent, in context: Context, completion: @escaping (FoodEntry) -> Void) {
        UserDefaults.standard.dictionaryRepresentation().forEach { (key, value) in
            UserDefaults.shared.set(value, forKey: key)
        }
        
        let resName = getRestaurantName()
        getMealData(resName: resName, completion: { data in
            let entry = FoodEntry(date: Date(), mealData: data.data ?? [], restaurantName: resName)
            completion(entry)
        })
    }
    
    func getTimeline(for configuration: RestaurantListIntent, in context: Context, completion: @escaping (Timeline<FoodEntry>) -> Void) {
        UserDefaults.standard.dictionaryRepresentation().forEach { (key, value) in
            UserDefaults.shared.set(value, forKey: key)
        }
        
        if let userCampus  = UserDefaults.shared.value(forKey: "userCampus") {
            switch userCampus as! String {
            case "인문캠퍼스":
                // MCC 설정
                getMealData(resName: "MCC식당") { data in
                    let currentDate = Date()
                    let entry = FoodEntry(date: currentDate, mealData: data.data ?? [], restaurantName: "MCC식당")
                    let nextRefresh = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
                    let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
                    completion(timeline)
                }
            case "자연캠퍼스":
                let resName = getYonginRestaurantName()
                getMealData(resName: resName) { data in
                    let currentDate = Date()
                    let entry = FoodEntry(date: currentDate, mealData: data.data ?? [], restaurantName: resName)
                    let nextRefresh = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
                    let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
                    completion(timeline)
                }
            default: return
            }
        }

    }
    
    typealias Intent = RestaurantListIntent
    typealias Entry = FoodEntry
    
    func placeholder(in context: Context) -> FoodEntry {
        FoodEntry(date: Date(), mealData: [], restaurantName: "선택된 식당 없음")
    }
    
    func getMealData(resName: String, completion: @escaping (WidgetAPIModel) -> ()) {
        
        let selectedRes = resName
        let urlString = baseURL + selectedRes
        if let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            guard let url = URL(string: encodedUrlString) else { return }

            URLSession.shared.dataTask(with: url) { data, response, error in
              guard
                let data = data,
                let foodModel = try? JSONDecoder().decode(WidgetAPIModel.self, from: data)
              else { return }
                completion(foodModel)
            }.resume()
        }
    }
    
    func getRestaurantName() -> String {
        if let userCampus  = UserDefaults.shared.value(forKey: "userCampus") {
            switch userCampus as! String {
            case "인문캠퍼스": return "MCC식당"
            case "자연캠퍼스": return "생활관식당"
            default: return ""
            }
        }
        return "식당 미선택"
    }
    
    func getYonginRestaurantName() -> String {
        if let res = UserDefaults.shared.value(forKey: "yongin_widget_res_name") {
            return res as! String
        }
        return "MCC식당" // 오류방지용
    }
}

struct FoodEntry: TimelineEntry {
    let date: Date
    var mealData: [DayFoodModel] = []
    var restaurantName: String
    
    func getFoodTypeStr(type: String) -> String {
        if restaurantName == "명진당식당" {
            switch type {
            case "LUNCH_A": return "샐러드"
            case "LUNCH_B": return "백반"
            case "DINNER": return "볶음밥"
            default: return "알 수 없음"
            }
        } else {
            switch type {
            case "LUNCH_A": return (mealData.count > 2) ? "중식A" : "중식"
            case "LUNCH_B": return "중식B"
            case "DINNER": return "석식"
            default: return "알 수 없음"
            }
        }
    }
    
    func getAttributedFoodsStr(type: String) -> AttributedString {
        var result = AttributedString(getMainFoodStr(type: type))
        result.font = .system(size: 13).bold()
        result.foregroundColor = Color(uiColor: UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1))
        if result != "" { result += " " }
        else { result += "" }
        result += AttributedString(getFoodsStr(type: type))
        return result
    }
    
    func getMainFoodStr(type: String) -> String {
        var mainFood: String = ""
        mealData.forEach { data in
            if data.mealType == type {
                mainFood += data.meals![0]
            }
        }
        return mainFood
    }
    
    func getFoodsStr(type: String) -> String {
        var foodStr: String = ""
        mealData.forEach { data in
            if data.mealType == type {
                foodStr += data.meals![1]
            }
        }
        return foodStr
    }
    
    func getTodayStr() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: Date())
    }
    
    func getLanchOperatingTimeStr(typeName: String) -> String {
        var operatingTime = ""
        switch typeName {
            case "MCC식당": operatingTime = OperatingTimeStr.mccLanch
            case "교직원식당": operatingTime = OperatingTimeStr.staffLanch
            case "생활관식당": operatingTime = OperatingTimeStr.dormitoryLanch
            case "학관식당": operatingTime = OperatingTimeStr.studentLanch
            case "명진당식당": operatingTime = OperatingTimeStr.myounginLanch
            default: return operatingTime
        }
        return operatingTime
    }
    
    func getDinnerOperatingTimeStr(typeName: String) -> String {
        var operatingTime = ""
        switch typeName {
            case "MCC식당": operatingTime = OperatingTimeStr.mccDinner
            case "교직원식당": operatingTime = OperatingTimeStr.staffDinner
            case "생활관식당": operatingTime = OperatingTimeStr.dormitoryDinner
            case "학관식당": operatingTime = OperatingTimeStr.studentDinner
            case "명진당식당": operatingTime = OperatingTimeStr.myounginDinner
            default: return operatingTime
        }
        return operatingTime
    }
}

// MARK: Widget의 content를 보여주는 SwiftUI View
struct DailyFoodWidgetEntryView : View {
    var entry: Provider.Entry
    
    let mealTypeTextWidth: CGFloat = 60
    let cellViewHeight: CGFloat = 93

    var body: some View {
        VStack(alignment: .center, spacing: 10, content: {
            
            /// 운영시간 & 식당명
            HStack(content: {
                Text(entry.getTodayStr())
                    .bold()
                    .foregroundColor(Color(uiColor: UIColor(red: 101/255, green: 101/255, blue: 101/255, alpha: 1)))
                    .font(.system(size: 11))
                Spacer()
                Text((entry.restaurantName == "학생식당") ? "학관식당" : entry.restaurantName)
                    .bold()
                    .foregroundColor(Color(uiColor: UIColor(red: 101/255, green: 101/255, blue: 101/255, alpha: 1)))
                    .font(.system(size: 11))
                
            }).padding(EdgeInsets(top: 20, leading: 30, bottom: 0, trailing: 30))
            

            /// 학식 종류명 & 학식 내용
            if entry.mealData.count > 0 {
                LazyVStack(alignment: .leading, content: {
                    
                    /// 중식
                    ForEach(0..<entry.mealData.count-1, content: { idx in
                        LazyHStack(alignment: .top, content: {
                            Text(entry.getFoodTypeStr(type: entry.mealData[idx].mealType ?? ""))
                               .font(.system(size: 14))
                               .bold()
                               .foregroundColor(Color(uiColor: UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1)))
                               .frame(width: mealTypeTextWidth)
                               .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))

                            Image("separator")
                                .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                            
                            LazyVStack(alignment: .leading, content: {
                                
                                Text(entry.getAttributedFoodsStr(type: entry.mealData[idx].mealType!))
                                    .font(.system(size: 13))
                                    .foregroundColor(.black)
                                    .padding(EdgeInsets(top: 0, leading: -5, bottom: 1, trailing: 0))
                                
                                Text(entry.getLanchOperatingTimeStr(typeName: entry.restaurantName))
                                    .font(.system(size: 8))
                                    .foregroundColor(.gray)
                                    .padding(EdgeInsets(top: 0, leading: -5, bottom: 0, trailing: 0))
                                
                            })
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            .frame(width: 210, height: cellViewHeight)
                            
                        })
                        .frame(height: cellViewHeight)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                
                    })
                })
                .background(Color(uiColor: UIColor(red: 246/255, green: 247/255, blue: 250/255, alpha: 1)))
                .frame(width: 300)
                .cornerRadius(16)
                
                
                /// 석식
                LazyVStack(alignment: .leading, content: {
                    
                    LazyHStack(alignment: .top, content: {
                        Text(entry.getFoodTypeStr(type: entry.mealData[entry.mealData.count-1].mealType ?? ""))
                           .font(.system(size: 14))
                           .bold()
                           .foregroundColor(Color(uiColor: UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1)))
                           .frame(width: mealTypeTextWidth)
                           .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))

                        Image("separator")
                            .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))

                        LazyVStack(alignment: .leading, content: {
                            
                            Text(entry.getAttributedFoodsStr(type: entry.mealData[entry.mealData.count-1].mealType!))
                                .font(.system(size: 13))
                                .foregroundColor(.black)
                                .padding(EdgeInsets(top: 0, leading: -5, bottom: 4, trailing: 0))
                            
                            Text(entry.getDinnerOperatingTimeStr(typeName: entry.restaurantName))
                                .font(.system(size: 8))
                                .foregroundColor(.gray)
                                .padding(EdgeInsets(top: 0, leading: -5, bottom: 0, trailing: 0))
                            
                        })
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        .frame(width: 210, height: cellViewHeight)
                        
                    })
                    .frame(height: cellViewHeight)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    
                })
                .background(Color(uiColor: UIColor(red: 246/255, green: 247/255, blue: 250/255, alpha: 1)))
                .frame(width: 300)
                .cornerRadius(16)
                
            
            } else {
                Text("금일 학생식당을 운영하지 않습니다.")
                    .bold()
                    .foregroundColor(.blue)
            }
        })
    }
}

struct DailyFoodWidget: Widget {
    static let kind: String = "DailyFoodWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: DailyFoodWidget.kind,
                            intent: RestaurantListIntent.self,
                            provider: Provider()) { entry in
            DailyFoodWidgetEntryView(entry: entry)
        }
    }
}

struct DailyFoodWidget_Previews: PreviewProvider {
    static var previews: some View {
        DailyFoodWidgetEntryView(entry: FoodEntry(date: Date(), mealData: [], restaurantName: ""))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
