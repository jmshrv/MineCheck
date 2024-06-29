//
//  MineCheckApp.swift
//  MineCheck
//
//  Created by James on 26/06/2024.
//

import SwiftUI
import SwiftData

@main
struct MineCheckApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ServerScreen()
            }
            .modelContainer(for: MinecraftServer.self)
        }
    }
}
