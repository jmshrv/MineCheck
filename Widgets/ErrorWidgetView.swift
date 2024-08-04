//
//  ErrorWidget.swift
//  WidgetsExtension
//
//  Created by James on 04/08/2024.
//

import SwiftUI
import WidgetKit

struct ErrorWidgetView: View {
    let entry: ErrorEntry
    
    var body: some View {
        VStack {
            Text(errorTitle)
                .font(.headline)
            Text(errorDescription)
                .foregroundStyle(.secondary)
        }
    }
    
    var errorDescription: LocalizedStringKey {
        switch entry.error {
        case .noServer:
            "Select server in widget config"
        case .pingFailed:
            "Failed to get server status"
        case .skinsFailed:
            "Failed to fetch player skins"
        }
    }
    
    var errorTitle: LocalizedStringKey {
        switch entry.error {
        case .noServer:
            "No Server Selected"
        case .pingFailed:
            "Connection Failed"
        case .skinsFailed:
            "Connection Failed"
        }
    }
}

#if !os(macOS)
#Preview(as: .accessoryRectangular) {
    ServerAccessoryRectangularWidget()
} timeline: {
    MinecheckTimelineEntry.error(
        .init(error: .noServer)
    )
}
#endif
