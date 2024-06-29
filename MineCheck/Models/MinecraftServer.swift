//
//  MinecraftServer.swift
//  MineCheck
//
//  Created by James on 28/06/2024.
//

import Foundation
import SwiftData

@Model
class MinecraftServer: Identifiable {
    var id = UUID()
    
    var name: String
    var hostname: String
    var port: UInt16
    
    required init(id: UUID = UUID(), name: String, hostname: String, port: UInt16) {
        self.id = UUID()
        self.name = name
        self.hostname = hostname
        self.port = port
    }
    
    init() {
        self.name = ""
        self.hostname = ""
        self.port = 25565
    }
}

extension MinecraftServer {
    static var mock: Self {
        .init(
            name: "A Minecraft Server",
            hostname: "example.com",
            port: 25565
        )
    }
}
