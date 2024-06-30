//
//  ModelContainer+previews.swift
//  MineCheck
//
//  Created by James on 30/06/2024.
//

import Foundation
import SwiftData

extension ModelContainer {
    static var previews: ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try! ModelContainer(for: MinecraftServer.self, configurations: config)
    }
}
