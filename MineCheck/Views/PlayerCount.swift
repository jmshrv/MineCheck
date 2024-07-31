//
//  PlayerCount.swift
//  MineCheck
//
//  Created by James on 31/07/2024.
//

import SwiftUI
import MinecraftPing

struct PlayerCount: View {
    let players: MinecraftPlayers
    
    var body: some View {
        Text("\(players.online)/\(players.max)")
            .contentTransition(.numericText())
    }
}

#Preview {
    PlayerCount(players: .init(max: 100, online: 10, sample: nil))
}
