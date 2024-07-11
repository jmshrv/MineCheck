//
//  ContentView.swift
//  MineCheck
//
//  Created by James on 26/06/2024.
//

import SwiftUI
import SwiftData

struct ServerScreen: View {
    @Query private var servers: [MinecraftServer]
    
    @State private var searchTerm = ""
    
    var body: some View {
        ServerList(searchTerm: searchTerm)
            .navigationTitle("MineCheck")
            .if(!servers.isEmpty) {
                $0.searchable(text: $searchTerm)
            }
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                #endif
                
                ToolbarItem(placement: .primaryAction) {
                    AddServerToolbarItem()
                }
            }
    }
}

#Preview {
    NavigationStack {
        ServerScreen()
    }
}
