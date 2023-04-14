//
//  DailyFoodWidget.swift
//  DailyFoodWidget
//
//  Created by 김초원 on 2023/04/12.
//

import WidgetKit
import SwiftUI

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
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> FoodEntry {
        FoodEntry(date: Date(), mealData: [], restaurantName: "선택된 식당 없음")
    }

    func getSnapshot(in context: Context, completion: @escaping (FoodEntry) -> ()) {
        print("getSnapshot called")
        getMealData(completion: { data in
            print(data)
            
            let entry = FoodEntry(date: Date(), mealData: data.data ?? [], restaurantName: "")
            completion(entry)
        })
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getMealData { data in
            let currentDate = Date()
            let entry = FoodEntry(date: currentDate, mealData: data.data ?? [], restaurantName: "MCC식당")
            let nextRefresh = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
            let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
            completion(timeline)
        }
    }
    
    func getMealData(completion: @escaping (WidgetAPIModel) -> ()) {
        print("getMealData called")
        let selectedRes = "MCC식당"
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
}

struct FoodEntry: TimelineEntry {
    let date: Date
    var mealData: [DayFoodModel]
    var restaurantName: String
    
    func getFoodTypeStr(type: String) -> String {
        switch type {
        case "LUNCH_A": return "중식A"
        case "LUNCH_B": return "중식B"
        case "DINNER": return "석식"
        default: return "알 수 없음"
        }
    }
    
    func getFoodStr(type: String) -> String {
        var foodStr: String = ""
        mealData.forEach { data in
            if data.mealType == type {
                data.meals?.forEach { meal in
                    foodStr += meal
                }
            }
        }
        return foodStr
    }
}

// MARK: Widget의 content를 보여주는 SwiftUI View
struct DailyFoodWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .center, spacing: 10, content: {
            Text("MCC식당").bold()

            if entry.mealData.count > 0 {
                ForEach(0..<entry.mealData.count, content: { idx in
                    LazyVStack(alignment: .leading, content: {
                        Text(entry.getFoodTypeStr(type: entry.mealData[idx].mealType ?? ""))
                            .font(.body)
                            .bold()
                            .foregroundColor(.blue)
                            .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.blue, lineWidth: 1.5)
                            )
                        
                        Text(entry.getFoodStr(type: entry.mealData[idx].mealType ?? "정보를 찾을 수 없음")).font(.body).foregroundColor(.gray)
                            .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                    }).padding(EdgeInsets(top: 0, leading: 25, bottom: 5, trailing: 25))

                })
            } else {
                Text("금일 학생식당을 운영하지 않습니다.")
                    .bold()
                    .foregroundColor(.gray)
            }
            
        })
    }
}

struct DailyFoodWidget: Widget {
    let kind: String = "DailyFoodWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DailyFoodWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct DailyFoodWidget_Previews: PreviewProvider {
    static var previews: some View {
        DailyFoodWidgetEntryView(entry: FoodEntry(date: Date(), mealData: [], restaurantName: ""))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
