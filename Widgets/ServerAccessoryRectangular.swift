//
//  ServerAccessoryRegular.swift
//  MineCheck
//
//  Created by James on 31/07/2024.
//

import SwiftUI
import MinecraftPing
import WidgetKit

struct ServerAccessoryRectangular: View {
    let server: MinecraftServer
    let status: MinecraftStatus
    let lastUpdate: Date
    
    var body: some View {
        HStack(alignment: .top) {
            Text(server.name)
                .font(.headline)
                .lineLimit(2)
            
            if let players = status.players {
                PlayerCount(players: players)
            }
        }
    }
}

#Preview(as: .accessoryRectangular) {
    ServerAccessoryRectangularWidget()
} timeline: {
    SimpleEntry(date: .now, server: .mock, status: .mock)
}
