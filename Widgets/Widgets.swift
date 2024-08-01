//
//  Widgets.swift
//  Widgets
//
//  Created by James on 04/07/2024.
//

import WidgetKit
import SwiftUI
import SwiftData
import MinecraftPing

struct Provider: AppIntentTimelineProvider {
    var sharedModelContainer: ModelContainer = { // Note that we create and assign this value;
        let schema = Schema([MinecraftServer.self])        // it is not a computed property.
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
          return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
          fatalError("Could not create ModelContainer: \(error)")
        }
      }()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), server: .mock, status: .mock, skins: [])
    }

    func snapshot(for configuration: MinecraftServerAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), server: .mock, status: .mock, skins: [])
    }
    
    func timeline(for configuration: MinecraftServerAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        guard let server = configuration.server else {
            return Timeline(
                entries: [SimpleEntry(date: Date(), server: .mock, status: .mock, skins: [])],
                policy: .after(
                    .now.addingTimeInterval(
                        15 * 60
                    )
                )
            )
        }
        
        let connection = MinecraftConnection(hostname: server.hostname, port: server.port)
        
        guard let status = try? await connection.ping() else {
            return Timeline(
                entries: [SimpleEntry(date: Date(), server: .mock, status: .mock, skins: [])],
                policy: .after(
                    .now.addingTimeInterval(
                        15 * 60
                    )
                )
            )
        }
        
        let skins = try? await status.players?.skins()

        return Timeline(
            entries: [SimpleEntry(
                date: .now,
                server: .init(
                    name: server.name,
                    hostname: server.hostname,
                    port: server.port
                ),
                status: status,
                skins: skins ?? []
            )],
            policy: .after(
                .now.addingTimeInterval(
                    15 * 60
                )
            )
        )
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let server: MinecraftServer
    let status: MinecraftStatus
    let skins: [(MinecraftPlayerSample, Data?)]
}

struct ServerSystemTile: Widget {
    let kind: String = "ServerSystemTile"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: MinecraftServerAppIntent.self, provider: Provider()) { entry in
            ServerListTileContent(server: entry.server, status: entry.status, lastUpdate: entry.date, skins: entry.skins)
                .containerBackground(.fill.tertiary, for: .widget)
                .modelContainer(for: MinecraftServer.self)
        }
        .supportedFamilies([.systemMedium])
    }
}

@available(iOS 17.0, watchOS 10.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
struct ServerAccessoryRectangularWidget: Widget {
    let kind: String = "ServerAccessoryRectangularWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: MinecraftServerAppIntent.self, provider: Provider()) { entry in
            ServerAccessoryRectangular(server: entry.server, status: entry.status, lastUpdate: entry.date, skins: entry.skins)
                .containerBackground(.fill.tertiary, for: .widget)
                .modelContainer(for: MinecraftServer.self)
        }
        .supportedFamilies([.accessoryRectangular])
    }
}


#Preview(as: .systemMedium) {
    ServerSystemTile()
} timeline: {
    SimpleEntry(date: .now, server: .mock, status: .mock, skins: [])
}
