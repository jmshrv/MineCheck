//
//  ServerListTile.swift
//  MineCheck
//
//  Created by James on 29/06/2024.
//

import SwiftUI
import MinecraftPing

struct ServerListTile: View {
    let server: MinecraftServer
    
    private let connection: MinecraftConnection
    
    @State private var status: MinecraftStatus?
    @State private var pingError: (any Error)?
    
    init(server: MinecraftServer) {
        self.server = server
        self.connection = .init(hostname: server.hostname, port: server.port)
    }
    
    var body: some View {
        Group {
            if let status {
                HStack {
                    VStack {
                        Text(server.name)
                        Text(server.hostname)
                    }
                    
                    if let players = status.players {
                        Text("\(players.online)/\(players.max)")
                    }
                }
            } else if let pingError {
                Text("\(pingError)")
            } else {
                ProgressView()
            }
        }
        .frame(height: 150)
        .task {
            do {
                try await status = connection.ping()
            } catch {
                pingError = error
            }
        }
    }
}
