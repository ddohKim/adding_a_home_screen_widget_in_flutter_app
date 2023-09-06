//
//  NewsWidgets.swift
//  NewsWidgets
//
//  Created by 김도현 on 2023/09/06.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {

// Placeholder is used as a placeholder when the widget is first displayed
    func placeholder(in context: Context) -> NewsArticleEntry {
//      Add some placeholder title and description, and get the current date
        NewsArticleEntry(date: Date(), title: "Placholder Title", description: "Placholder description", filename: "No screenshot available",  displaySize: context.displaySize)

    }

// Snapshot entry represents the current time and state
    func getSnapshot(in context: Context, completion: @escaping (NewsArticleEntry) -> ()) {
      let entry: NewsArticleEntry
      if context.isPreview{
        entry = placeholder(in: context)
      }
      else{
        //      Get the data from the user defaults to display
          let userDefaults = UserDefaults(suiteName: "group.testingtesting")
        let title = userDefaults?.string(forKey: "headline_title") ?? "No Title Set"
        let description = userDefaults?.string(forKey: "headline_description") ?? "No Description Set"
          let filename = userDefaults?.string(forKey: "filename") ?? "No screenshot available"

        entry = NewsArticleEntry(date: Date(), title: title, description: description,filename: filename, displaySize: context.displaySize)
      }
        completion(entry)
    }

//    getTimeline is called for the current and optionally future times to update the widget
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//      This just uses the snapshot function you defined earlier
      getSnapshot(in: context) { (entry) in
// atEnd policy tells widgetkit to request a new entry after the date has passed
        let timeline = Timeline(entries: [entry], policy: .atEnd)
                  completion(timeline)
              }
    }
}


//View that holds the contents of the widget
struct NewsWidgetsEntryView : View {
    var entry: Provider.Entry

    // New: Add the helper function.
       var bundle: URL {
               let bundle = Bundle.main
               if bundle.bundleURL.pathExtension == "appex" {
                   // Peel off two directory levels - MY_APP.app/PlugIns/MY_APP_EXTENSION.appex
                   var url = bundle.bundleURL.deletingLastPathComponent().deletingLastPathComponent()
                   url.append(component: "Frameworks/App.framework/flutter_assets")
                   return url
               }
               return bundle.bundleURL
           }
    
    // New: Register the font.
       init(entry: Provider.Entry){
         self.entry = entry
         CTFontManagerRegisterFontsForURL(bundle.appending(path: "/fonts/Chewy-Regular.ttf") as CFURL, CTFontManagerScope.process, nil)
       }
    
    var body: some View {
      VStack {
        Text(entry.title).font(Font.custom("Chewy", size: 13))
        Text(entry.description).font(.system(size: 12)).padding(10)
            // New: add the ChartImage to the NewsWidgetEntryView
        ChartImage
      }
    }
    
    var ChartImage: some View {
         if let uiImage = UIImage(contentsOfFile: entry.filename) {
             let image = Image(uiImage: uiImage)
                 .resizable()
                 .frame(width: entry.displaySize.height*0.5, height: entry.displaySize.height*0.5, alignment: .center)
             return AnyView(image)
         }
         print("The image file could not be loaded")
         return AnyView(EmptyView())
     }
}


struct NewsWidgets: Widget {
    let kind: String = "NewsWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NewsWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

//struct NewsWidgets_Previews: PreviewProvider {
//    static var previews: some View {
//        NewsWidgetsEntryView(entry: SimpleEntry(date: Date()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}

struct NewsArticleEntry: TimelineEntry {
    let date: Date
    let title: String
    let description:String
    let filename: String
    let displaySize: CGSize
}
