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
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Nickname", text: $server.name)
                    #if os(iOS)
                    .textInputAutocapitalization(.words)
                    #endif
                HStack {
                    TextField("Hostname", text: $server.hostname)
                        .frame(maxWidth: .infinity)
                        #if os(iOS)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        #endif
                    #if os(iOS)
                    Divider()
                    #endif
                    TextField("Port", value: $server.port, formatter: numberFormatter)
                        .frame(width: 100)
                        #if os(iOS)
                        .keyboardType(.numberPad)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        #else
                        .labelsHidden()
                        #endif
                }
            }
            .navigationTitle("Add Server")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) {
                        context.insert(server)
                        dismiss()
                    }
                    .disabled(!isValid)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                        dismiss()
                    }
                }
            }
            #if os(macOS)
            .frame(width: 400)
            .padding()
            #endif
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

#Preview("Sheet") {
    NavigationStack {
        Text("Hello, World!")
            .sheet(isPresented: .constant(true)) {
                AddServerSheet()
            }
    }
    .modelContainer(for: MinecraftServer.self, inMemory: true)
}
