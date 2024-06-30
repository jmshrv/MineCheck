//
//  ServerListTile.swift
//  MineCheck
//
//  Created by James on 29/06/2024.
//

import SwiftData
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
                ServerListTileContent(server: server, status: status)
            } else if let pingError {
                Text("\(pingError)")
            } else {
                ProgressView()
            }
        }
//        .frame(height: 150)
        .task {
            do {
                try await status = connection.ping()
            } catch {
                pingError = error
            }
        }
    }
}

struct ServerListTileContent: View {
    let server: MinecraftServer
    let status: MinecraftStatus
    
    var body: some View {
        HStack {
            if let favicon = try? status.faviconOrPackImage {
                favicon
                    .resizable()
                    .interpolation(.none)
                    .frame(width: 64, height: 64)
                    .clipShape(.rect(cornerRadius: 4))
            }
            
            VStack(alignment: .leading) {
                Text(server.name)
                    .font(.headline)
                
                if let description = status.description?.actualText {
                    Text(description)
                        .font(.footnote)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                if let players = status.players {
                    Text("\(players.online)/\(players.max)")
                        .font(.headline)
                    
                    if let sample = players.sample {
                        ForEach(sample) { player in
                            Text(player.name)
                                .font(.footnote)
                        }
                    }
                } else {
                    Text("???")
                }
            }
        }
    }
}

#Preview("Single") {
    let container = ModelContainer.previews
    
    return ServerListTileContent(server: .mock, status: .mock)
        .modelContainer(container)
}

#Preview("List") {
    let container = ModelContainer.previews
    
    return List {
        ServerListTileContent(server: .mock, status: .mock)
        ServerListTileContent(server: .mock, status: .mock)
        ServerListTileContent(server: .mock, status: .mock)
    }
    .modelContainer(container)
}
