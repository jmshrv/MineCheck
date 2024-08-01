//
//  ServerAccessoryRegular.swift
//  MineCheck
//
//  Created by James on 31/07/2024.
//

import SwiftUI
import MinecraftPing
import WidgetKit

@available(iOS 17.0, watchOS 10.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
struct ServerAccessoryRectangular: View {
    let server: MinecraftServer
    let status: MinecraftStatus
    let lastUpdate: Date
    let skins: [(MinecraftPlayerSample, Data?)]
    
    var body: some View {
        ZStack(alignment: .top) {
            HStack(alignment: .top) {
                Text(server.name)
                    .font(.headline)
                
                Spacer()
                
                if let players = status.players {
                    VStack(alignment: .trailing, spacing: 4) {
                        PlayerCount(players: players)
                            .font(.headline)
                    }
                }
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    PlayerSkinList(skins: skins)
                }
            }
        }
        
//        VStack {
//            HStack(alignment: .top) {
//                Text(server.name)
//                    .font(.headline)
//                    .lineLimit(2)
//                
//                Spacer()
//                
//                if let players = status.players {
//                    PlayerCount(players: players)
//                        .font(.headline)
//                }
//            }
//            
//            Spacer()
//            
//            PlayerSkinList(skins: skins)
//        }
    }
}

#if !os(macOS)
#Preview(as: .accessoryRectangular) {
    ServerAccessoryRectangularWidget()
} timeline: {
    SimpleEntry(date: .now,
                server: .mock,
                status: .mock,
                skins: (0...4).map {
        _ in (.init(name: "Test", id: .init()), nil)
    })
}
#endif
