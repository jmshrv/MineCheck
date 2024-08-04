//
//  Timeline+Entry.swift
//  WidgetsExtension
//
//  Created by James on 04/08/2024.
//

import WidgetKit

extension Timeline {
    /// A convenience initialiser to make a timeline with a single entry, which refreshes after 15 minutes.
    init(entry: EntryType) {
        self = Timeline(
            entries: [entry],
            policy: .after(.now.addingTimeInterval(15 * 60))
        )
    }
}

#Preview(as: .systemMedium) {
    ServerSystemTile()
} timeline: {
    MinecheckTimelineEntry.error(.init(error: .noServer))
}
