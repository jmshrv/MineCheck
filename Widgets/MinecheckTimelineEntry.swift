//
//  MinecheckTimelineEntry.swift
//  WidgetsExtension
//
//  Created by James on 04/08/2024.
//

import MinecraftPing
import WidgetKit

enum MinecheckTimelineEntry: TimelineEntry {
    case success(SuccessEntry)
    case error(ErrorEntry)
    
    var date: Date {
        switch self {
        case .success(let successEntry):
            successEntry.date
        case .error(let errorEntry):
            errorEntry.date
        }
    }
}

struct SuccessEntry: TimelineEntry {
    let date: Date = .now
    let server: MinecraftServer
    let status: MinecraftStatus
    let skins: [(MinecraftPlayerSample, Data?)]
}

struct ErrorEntry: TimelineEntry {
    let date: Date = .now
    let error: MineCheckWidgetError
}

enum MineCheckWidgetError: Error {
    case noServer
    case pingFailed(any Error)
    case skinsFailed(any Error)
}
