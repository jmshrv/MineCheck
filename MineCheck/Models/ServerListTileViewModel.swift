//
//  ServerListTileViewModel.swift
//  MineCheck
//
//  Created by James on 01/07/2024.
//

import SwiftUI
import MinecraftPing

@Observable
class ServerListTileViewModel {
    let server: MinecraftServer
    
    var status: MinecraftStatus?
    var pingError: (any Error)?
    var lastUpdate: Date = .now
    
    var wasEverLoaded = false
    
    init(server: MinecraftServer) {
        self.server = server
    }
    
    func onAppear(force: Bool = false) async {
        wasEverLoaded = true
        
        if status != nil {
            if !force {
                return
            }
        }
        
        let connection = MinecraftConnection(hostname: server.hostname, port: server.port)
        
        do {
            let result = try await connection.ping()
            
            withAnimation {
                status = result
                lastUpdate = .now
            }
            
        } catch {
            withAnimation {
                status = nil
                lastUpdate = .now
                pingError = error
            }
        }
    }
    
    func refresh() async {
        if !wasEverLoaded {
            return
        }
        
//        status = nil
        withAnimation {
            pingError = nil
        }
        
        await onAppear(force: true)
    }
}
