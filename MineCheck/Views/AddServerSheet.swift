//
//  AddServerSheet.swift
//  MineCheck
//
//  Created by James on 28/06/2024.
//

import SwiftUI

struct AddServerSheet: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State var server: MinecraftServer = .init()
    
    @State var showListTile = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Server Info") {
                    TextField("Nickname", text: $server.name)
                        #if os(iOS)
                        .textInputAutocapitalization(.words)
                        #endif
                    HStack {
                        TextField("Hostname", text: $server.hostname)
                            #if os(iOS)
                            .keyboardType(.URL)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            #endif
                        Divider()
                        TextField("Port", value: $server.port, formatter: numberFormatter)
                            #if os(iOS)
                            .keyboardType(.numberPad)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            #endif
                    }
                }
                
                if showListTile {
                    Section("Preview") {
                        ServerListTile(server: server)
                    }
                    .animation(.spring, value: showListTile)
                }
            }
            .navigationTitle("Add Server")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add") {
                        context.insert(server)
                        dismiss()
                    }
                    .disabled(!isValid)
                }
            }
        }
        .onAppear {
            showListTile = isValid
        }
        .onChange(of: isValid) {
            withAnimation {
                showListTile = isValid
            }
        }
    }
    
    private var isValid: Bool {
        !server.name.isEmpty && !server.hostname.isEmpty
    }
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximum = .init(integerLiteral: Int(UInt16.max))
        formatter.generatesDecimalNumbers = false
        
        return formatter
    }
}

#Preview {
    NavigationStack {
        Text("Hello, World!")
            .sheet(isPresented: .constant(true)) {
                AddServerSheet()
            }
    }
    .modelContainer(for: MinecraftServer.self, inMemory: true)
}
