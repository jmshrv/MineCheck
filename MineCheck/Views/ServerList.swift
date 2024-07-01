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
    
    @Query(sort: \MinecraftServer.name) private var servers: [MinecraftServer]
    
    private var isSearching = false
    
    init() {}
    
    init(searchTerm: String) {
        isSearching = !searchTerm.isEmpty
        
        if !searchTerm.isEmpty {
            _servers = Query(
                filter: #Predicate { $0.name.localizedStandardContains(searchTerm) },
                sort: \MinecraftServer.name
            )
        }
    }
    
    var body: some View {
        if servers.isEmpty {
            if isSearching {
                ContentUnavailableView.search
            } else {
                ContentUnavailableView(
                    "No Servers",
                    systemImage: "server.rack",
                    description: Text("Tap the \(Image(systemName: "plus")) button to add a server.")
                )
            }
        } else {
            List {
                ForEach(servers) { server in
                    ServerListTile(server: server)
                }
                .onDelete { indexSet in
                    let serversToDelete = indexSet.map { servers[$0] }
                    
                    for server in serversToDelete {
                        context.delete(server)
                    }
                }
            }
            .refreshable {}
        }
    }
}
