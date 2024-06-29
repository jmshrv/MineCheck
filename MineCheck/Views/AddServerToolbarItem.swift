//
//  AddServerToolbarItem.swift
//  MineCheck
//
//  Created by James on 28/06/2024.
//

import SwiftUI

struct AddServerToolbarItem: View {
    @State private var isSheetPresented = false
    
    var body: some View {
        Button("Add server", systemImage: "plus", action: addServerAction)
            .sheet(isPresented: $isSheetPresented) {
                AddServerSheet()
            }
    }
    
    func addServerAction() {
        isSheetPresented.toggle()
    }
}

#Preview {
    NavigationStack {
        Text("Hello, World!")
            .navigationTitle("Test")
            .toolbar {
                AddServerToolbarItem()
            }
    }
}
