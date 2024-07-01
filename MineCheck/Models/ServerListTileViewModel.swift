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
    
    init(server: MinecraftServer) {
        self.server = server
    }
    
    func onAppear(force: Bool = false) async {
        if status != nil {
            if !force {
                return
            }
        }
        
        let connection = MinecraftConnection(hostname: server.hostname, port: server.port)
        
        do {
            status = try await connection.ping()
        } catch {
            pingError = error
        }
    }
    
    func refresh() async {
//        status = nil
        pingError = nil
        await onAppear(force: true)
    }
}
