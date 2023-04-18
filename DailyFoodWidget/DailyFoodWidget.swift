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
    static let mccLanch = "중식 운영 시간 11:30~14:00"
    static let mccDinner = "석식 운영 시간 17:30~19:00"
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
    
    func getFoodsStr(type: String) -> String {
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
    
    func getTodayStr() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: Date())
    }
}

// MARK: Widget의 content를 보여주는 SwiftUI View
struct DailyFoodWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .center, spacing: 10, content: {
            
            /// 운영시간 & 식당명
            HStack(content: {
                Text(entry.getTodayStr())
                    .bold()
                    .foregroundColor(Color(uiColor: UIColor(red: 101/255, green: 101/255, blue: 101/255, alpha: 1)))
                    .font(.system(size: 11))
                Spacer()
                Text("MCC식당")
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
                               .padding(EdgeInsets(top: 8, leading: 10, bottom: 0, trailing: 10))
                            
                            Image("separator")
                                .padding(EdgeInsets(top: 7, leading: 0, bottom: 0, trailing: 0))
                            
                            LazyVStack(alignment: .leading, content: {
                                
                                Text(entry.getFoodsStr(type: entry.mealData[idx].mealType ?? "정보를 찾을 수 없음"))
                                    .font(.system(size: 13))
                                    .foregroundColor(.black)
                                    .padding(EdgeInsets(top: 0, leading: -5, bottom: 1, trailing: 0))
                                
                                Text(OperatingTimeStr.mccLanch)
                                    .font(.system(size: 8))
                                    .foregroundColor(.gray)
                                
                            })
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            .frame(width: 210, height: 83)
                            
                        })
                        .frame(height: 83)
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
                           .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 18))
                        
                        Image("separator")
                            .padding(EdgeInsets(top: 7, leading: 0, bottom: 0, trailing: 0))
                        
                        LazyVStack(alignment: .leading, content: {
                            
                            Text(entry.getFoodsStr(type: entry.mealData[entry.mealData.count-1].mealType ?? "정보를 찾을 수 없음"))
                                .font(.system(size: 13))
                                .foregroundColor(.black)
                                .padding(EdgeInsets(top: 0, leading: -5, bottom: 4, trailing: 0))
                            
                            Text(OperatingTimeStr.mccDinner)
                                .font(.system(size: 8))
                                .foregroundColor(.gray)
                            
                        })
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        .frame(width: 210, height: 83)
                        
                    })
                    .frame(height: 83)
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
               
                // 원본
//            if entry.mealData.count > 0 {
//                LazyVStack(content: {
//                ForEach(0..<entry.mealData.count, content: { idx in
//                    LazyVStack(alignment: .leading, content: {
//                        Text(entry.getFoodTypeStr(type: entry.mealData[idx].mealType ?? ""))
//                            .font(.body)
//                            .bold()
//                            .foregroundColor(.blue)
//                            .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 14)
//                                    .stroke(Color.blue, lineWidth: 1.5)
//                            )
//
//                        Text(entry.getFoodStr(type: entry.mealData[idx].mealType ?? "정보를 찾을 수 없음")).font(.body).foregroundColor(.gray)
//                            .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
//                    }).padding(EdgeInsets(top: 0, leading: 25, bottom: 5, trailing: 25))
                    
//
//                        LazyHStack(alignment: .top, content: {
//                            VStack(content: {
//                                Text(entry.getFoodTypeStr(type: entry.mealData[idx].mealType ?? ""))
//                                    .font(.system(size: 14))
//                                    .bold()
//                                    .foregroundColor(Color(uiColor: UIColor(red: 10/255, green: 69/255, blue: 202/255, alpha: 1)))
//                            })
////                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
//                                .background(Color.brown)
//
//                            Spacer()
//                            LazyVStack(alignment: .leading, content: {
//
//                                Text("식단 내용 어쩌고 저쩌고 식단 내용 어쩌고 저쩌고 식단 내용 어쩌고 저쩌고")
//                                    .font(.system(size: 14))
//                                    .foregroundColor(.gray)
//                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
//
//                                Text("운영시간 00:00 ~ 00:00")
//                                    .font(.system(size: 8))
//                                    .foregroundColor(.gray)
//
//                            }).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
//                                .frame(width: 210)
//                                .background(Color.red)
//
//                        }).background(Color.orange)

//                })
//
//            } else {
//                Text("금일 학생식당을 운영하지 않습니다.")
//                    .bold()
//                    .foregroundColor(.blue)
//            }
            
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
