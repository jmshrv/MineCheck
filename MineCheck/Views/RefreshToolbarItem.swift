//
//  RefreshToolbarItem.swift
//  MineCheck
//
//  Created by James on 11/07/2024.
//

import SwiftUI

struct RefreshToolbarItem: View {
    @Environment(\.refresh) private var refresh
    
    var body: some View {
        Button("Refresh", systemImage: "arrow.clockwise") {
            Task {
                await refresh?()
            }
        }
        .disabled(refresh == nil)
        .keyboardShortcut("r")
    }
}

#Preview {
    RefreshToolbarItem()
}
