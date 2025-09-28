//
//  MinecraftServer.swift
//  MineCheck
//
//  Created by James on 28/06/2024.
//

import AppIntents
import Foundation
import SwiftData
import OSLog

@Model
final class MinecraftServer: Identifiable {
    var id = UUID()
    
    var name: String
    var hostname: String
    var port: UInt16
    
    required init(id: UUID = UUID(), name: String, hostname: String, port: UInt16) {
        self.id = id
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

struct MinecraftServerAppEntity: AppEntity, Identifiable {
    let id: UUID
    
    let name: String
    let hostname: String
    let port: UInt16
    
    static let defaultQuery = MinecraftServerEntityQuery()
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(
            name: LocalizedStringResource("Server", table: "AppIntents"),
            numericFormat: LocalizedStringResource("\(placeholder: .int) servers", table: "AppIntents")
        )
    }
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(name)",
            subtitle: LocalizedStringResource(stringLiteral: "\(hostname):\(port)") // Initialised like this to remove separators from port
        )
    }
}

struct MinecraftServerEntityQuery: EntityQuery {
    func entities(for identifiers: [MinecraftServerAppEntity.ID]) async throws -> [MinecraftServerAppEntity] {
        let container = try ModelContainer(for: MinecraftServer.self)
        let context = ModelContext(container)
        
        let servers = try context.fetch(FetchDescriptor<MinecraftServer>(
            predicate: #Predicate { identifiers.contains($0.id) },
            sortBy: [.init(\.name)])
        )
        
        let entities = servers.map { MinecraftServerAppEntity(
            id: $0.id,
            name: $0.name,
            hostname: $0.hostname,
            port: $0.port
        ) }
        
        return entities
    }
    
    func suggestedEntities() async throws -> [MinecraftServerAppEntity] {
        let container = try ModelContainer(for: MinecraftServer.self)
        let context = ModelContext(container)
        
        let servers = try context.fetch(FetchDescriptor<MinecraftServer>(sortBy: [.init(\.name)]))
        
        let entities = servers.map { MinecraftServerAppEntity(
            id: $0.id,
            name: $0.name,
            hostname: $0.hostname,
            port: $0.port
        ) }
        
        return entities
    }
}
