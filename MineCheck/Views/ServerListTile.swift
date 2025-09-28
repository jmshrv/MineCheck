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
    @Environment(\.scenePhase) private var scenePhase
    
    let viewModel: ServerListTileViewModel
    
    var body: some View {
        Group {
            if let status = viewModel.status {
                ServerListTileContent(server: viewModel.server, status: status, lastUpdate: viewModel.lastUpdate, skins: viewModel.skins)
            } else if let pingError = viewModel.pingError {
                HStack {
                    Image(systemName: "exclamationmark.square.fill")
                        .resizable()
                        .foregroundStyle(.secondary)
                        .frame(width: 64, height: 64)
                        .padding(.trailing, 10)
                    VStack(alignment: .leading) {
                        Text(viewModel.server.name)
                            .font(.headline)
                        Text(pingError.localizedDescription)
                            .font(.footnote)
                    }
                }
            } else {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .frame(minHeight: 64)
        .task {
            await viewModel.onAppear()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                Task {
                    await viewModel.refresh()
                }
            }
        }
    }
}

struct ServerListTileContent: View {
    let server: MinecraftServer
    let status: MinecraftStatus
    let lastUpdate: Date
    let skins: [(MinecraftPlayerSample, Data?)]
    
    var body: some View {
        HStack {
            if let favicon = try? status.faviconOrPackImage {
                favicon
                    .resizable()
                    .interpolation(.none)
                    .frame(width: 64, height: 64)
                    .clipShape(.rect(cornerRadius: 12))
                    .padding(.trailing, 12)
            }
            
            VStack(alignment: .leading) {
                Text(server.name)
                    .font(.headline)
                    .lineLimit(2)
                
                if let description = status.description?.actualText {
                    Text(description)
                        .font(.footnote)
                }
                
                Text("Last update: \(lastUpdate, style: .time)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                if let players = status.players {
                    PlayerCount(players: players)
                        .font(.headline)
                    if let sample = players.sample?.sorted(by: { $0.name.localizedStandardCompare($1.name) == .orderedAscending }) {
                        ForEach(sample) { player in
                            Text(player.name)
                                .font(.footnote)
                        }
                        
                        PlayerSkinList(skins: skins)
                    }
                } else {
                    Text("???")
                        .font(.headline)
                }
            }
        }
    }
}

#Preview("Single") {
    let container = ModelContainer.previews
    
    return ServerListTileContent(server: .mock, status: .mock, lastUpdate: .now, skins: [])
        .modelContainer(container)
}

#Preview("List") {
    let container = ModelContainer.previews
    
    return List {
        ServerListTileContent(server: .mock, status: .mock, lastUpdate: .now, skins: [])
        ServerListTileContent(server: .mock, status: .mock, lastUpdate: .now, skins: [])
        ServerListTileContent(server: .mock, status: .mock, lastUpdate: .now, skins: [])
    }
    .modelContainer(container)
}
