//
//  ServerList.swift
//  MineCheck
//
//  Created by James on 28/06/2024.
//

import SwiftUI
import SwiftData

struct ServerList: View {
    @Environment(\.modelContext) private var context
    
    @Query(sort: \MinecraftServer.name) private var allServers: [MinecraftServer]
    
    var body: some View {
        List {
            ForEach(allServers) { server in
                ServerListTile(server: server)
            }
            .onDelete { indexSet in
                let servers = indexSet.map { allServers[$0] }
                
                for server in servers {
                    context.delete(server)
                }
            }
        }
        .refreshable {}
    }
}
