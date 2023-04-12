//
//  DailyFoodWidget.swift
//  DailyFoodWidget
//
//  Created by 김초원 on 2023/04/12.
//

import WidgetKit
import SwiftUI

// MARK: 위젯을 새로고침할 타임라인을 결정하는 객체
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

// MARK: Widget의 content를 보여주는 SwiftUI View
struct DailyFoodWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .center, spacing: 10, content: {
            Text("MCC식당").bold()
            
            VStack(alignment: .leading, content: {
                Text(" 중식A ")
                    .font(.body)
                    .bold()
                    .foregroundColor(.blue)
                    .padding(3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.blue, lineWidth: 1.5)
                    )
                Text("참치김치찌개&라면사리 쌀밥 마늘닭강정 건파래볶음 오이부추생채 배추김치").font(.body).foregroundColor(.gray)
                    .padding(10)
            })
            
            VStack(alignment: .leading, content: {
                Text(" 중식B ")
                    .font(.body)
                    .bold()
                    .foregroundColor(.blue)
                    .padding(3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.blue, lineWidth: 1.5)
                    )
                Text("참치김치찌개&라면사리 쌀밥 마늘닭강정 건파래볶음 오이부추생채 배추김치").font(.body).foregroundColor(.gray)
                    .padding(10)
            })
            
            VStack(alignment: .leading, content: {
                Text(" 석식 ")
                    .font(.body)
                    .bold()
                    .foregroundColor(.blue)
                    .padding(3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.blue, lineWidth: 1.5)
                    )
                Text("참치김치찌개&라면사리 쌀밥 마늘닭강정 건파래볶음 오이부추생채 배추김치").font(.body).foregroundColor(.gray)
                    .padding(10)
            })
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
        DailyFoodWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
