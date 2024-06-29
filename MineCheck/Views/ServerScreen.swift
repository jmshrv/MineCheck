//
//  ContentView.swift
//  MineCheck
//
//  Created by James on 26/06/2024.
//

import SwiftUI

struct ServerScreen: View {
    var body: some View {
        ServerList()
            .navigationTitle("Servers")
            .toolbar {
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
