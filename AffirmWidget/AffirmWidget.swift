//
//  AffirmWidget.swift
//  AffirmWidget
//
//  Created by evpes on 23.05.2021.
//

import WidgetKit
import SwiftUI
import Intents

let snapshotEntry = WidgetContent(affirmText: "I love myself")

struct Provider: TimelineProvider {
    
    func getSnapshot(in context: Context, completion: @escaping (WidgetContent) -> Void) {
        let entry = snapshotEntry
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetContent>) -> Void) {
        var entries = readContents()
        print("entries :\(entries)")
        if entries.count == 0 {
            entries = DefaultWidgetContent.entries
        }

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let interval = 300
        for index in 0 ..< entries.count {
          entries[index].date = Calendar.current.date(byAdding: .second,
            value: index * interval, to: currentDate)!
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func readContents() -> [Entry] {
      var contents: [WidgetContent] = []
      let archiveURL = FileManager.sharedContainerURL().appendingPathComponent("contents.json")
      print(">>> \(archiveURL)")

      let decoder = JSONDecoder()
      if let codeData = try? Data(contentsOf: archiveURL) {
        do {
          contents = try decoder.decode([WidgetContent].self, from: codeData)
        } catch {
          print("Error: Can't decode contents")
        }
      }
      return contents
    }
    
    func placeholder(in context: Context) -> WidgetContent {
        snapshotEntry
    }

}




@main
struct AffirmWidget: Widget {
    let kind: String = "AffirmWidget"

    public var body: some WidgetConfiguration {
      StaticConfiguration(
        kind: kind,
        provider: Provider()
      ) { entry in
        EntryView(model: entry)
      }
      .configurationDisplayName("Affirmations text")
      .description("Be yourself")
    }
}

struct AffirmWidget_Previews: PreviewProvider {
    static var previews: some View {
        EntryView(model: snapshotEntry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
