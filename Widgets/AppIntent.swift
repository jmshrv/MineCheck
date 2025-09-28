//
//  AppIntent.swift
//  Widgets
//
//  Created by James on 04/07/2024.
//

import WidgetKit
import AppIntents

struct MinecraftServerAppIntent: WidgetConfigurationIntent {
    static let title: LocalizedStringResource = "Server"

    @Parameter(title: "Server")
    var server: MinecraftServerAppEntity?
}
