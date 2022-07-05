//
//  LockScreenWidgets.swift
//  LockScreenWidgets
//
//  Created by Ahmet Kaan Kara on 5.07.2022.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct LockScreenWidgetsEntryView : View {
    
    @Environment(\.widgetFamily) private var family
    
    var entry: Provider.Entry

    var body: some View {
        
        
        // Mark: Switch Case for each widget family
        switch family {
            
            
        case .accessoryCircular:
            Gauge(value: 55,in: 0...100) {
                Image(systemName: "camera")
            }currentValueLabel: {
                Text("55")
            }
            .gaugeStyle(.accessoryCircular)
            
            
            
        case .accessoryRectangular:
            VStack(alignment:.leading){
                HStack(alignment:.firstTextBaseline){
                    Image(systemName: "person")
                    Text("Person")
                }
                .font(.headline)
                .widgetAccentable()
                
                Gauge(value: 20,in: 0...100){
                }
                                
            }
            .frame(maxWidth:.infinity,alignment: .leading)
            
            
        case .accessoryInline:
         
            HStack{
                Image(systemName:"cloud")
                Text("36°")
            }
            
        default:
            Color.clear
        }
    }
}

@main
struct LockScreenWidgets: Widget {
    let kind: String = "LockScreenWidgets"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            LockScreenWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        
        //Mark We have to add supported families
        .supportedFamilies([.accessoryCircular,.accessoryRectangular,.accessoryInline])
    }
}

struct LockScreenWidgets_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenWidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
    }
}
