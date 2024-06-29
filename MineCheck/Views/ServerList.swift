//
//  ServerList.swift
//  MineCheck
//
//  Created by James on 28/06/2024.
//

import SwiftUI
import SwiftData

struct ServerList: View {
    @Query(sort: \MinecraftServer.name) var allServers: [MinecraftServer]
    
    var body: some View {
        List {
            ForEach(allServers) { server in
                ServerListTile(server: server)
            }
        }
    }
}
