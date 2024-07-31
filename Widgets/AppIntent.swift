//
//  AppIntent.swift
//  Widgets
//
//  Created by James on 04/07/2024.
//

import WidgetKit
import AppIntents

struct MinecraftServerAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Server"

    @Parameter(title: "Server")
    var server: MinecraftServerAppEntity?
}
