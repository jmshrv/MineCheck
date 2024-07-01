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
    
    @State private var isSearching = false
    
    @State private var viewModels: [(UUID, ServerListTileViewModel)] = []
    
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
                ForEach(viewModels, id: \.0) { viewModel in
                    ServerListTile(viewModel: viewModel.1)
                }
                .onDelete { indexSet in
                    let serversToDelete = indexSet.map { servers[$0] }
                    
                    for server in serversToDelete {
                        context.delete(server)
                    }
                }
            }
            .onAppear {
                initViewModels()
            }
            .onChange(of: servers) {
                initViewModels()
            }
            .refreshable {
                await withDiscardingTaskGroup { group in
                    for viewModel in viewModels {
                        group.addTask {
                            await viewModel.1.refresh()
                        }
                    }
                }
            }
        }
    }
    
    func initViewModels() {
        viewModels = servers.map { ($0.id, .init(server: $0)) }
    }
}
