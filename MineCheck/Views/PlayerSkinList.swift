//
//  PlayerSkinList.swift
//  MineCheck
//
//  Created by James on 01/08/2024.
//

import SwiftUI
import MinecraftPing

private let scaleFactor = 2.0

struct PlayerSkinList: View {
    let skins: [(MinecraftPlayerSample, Data?)]
    
    private let columns = [
        GridItem(.adaptive(minimum: 8 * scaleFactor), spacing: 4)
    ]
    
    var body: some View {
//        LazyVGrid(columns: columns, spacing: 4) {
        HStack(spacing: 4) {
            ForEach(skins, id: \.0.id) { (player, skinData) in
                PlayerSkin(skinData: skinData)
                    .scaleEffect(x: scaleFactor, y: scaleFactor)
                    .frame(width: 8 * scaleFactor, height: 8 * scaleFactor)
            }
        }
    }
}

#Preview {
    PlayerSkinList(skins: (0...500).map { _ in (.init(name: "Test", id: .init()), nil) })
}
