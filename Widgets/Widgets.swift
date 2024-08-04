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
    
    func placeholder(in context: Context) -> MinecheckTimelineEntry {
        .success(
            .init(
                server: .mock,
                status: .mock,
                skins: []
            )
        )
    }

    func snapshot(for configuration: MinecraftServerAppIntent, in context: Context) async -> MinecheckTimelineEntry {
        await timeline(for: configuration, in: context).entries.first!
    }
    
    func timeline(for configuration: MinecraftServerAppIntent, in context: Context) async -> Timeline<MinecheckTimelineEntry> {
        guard let server = configuration.server else {
            return .init(entry: .error(.init(error: .noServer)))
        }
        
        let connection = MinecraftConnection(hostname: server.hostname, port: server.port)
        
        var status: MinecraftStatus
        do {
            status = try await connection.ping()
        } catch {
            return .init(entry: .error(.init(error: .pingFailed(error))))
        }
        
        var skins: [(MinecraftPlayerSample, Data?)]?
        do {
            skins = try await status.players?.skins()
        } catch {
            return .init(entry: .error(.init(error: .skinsFailed(error))))
        }

        return Timeline(
            entry: .success(
                .init(
                    server: .init(
                        name: server.name,
                        hostname: server.hostname,
                        port: server.port
                    ),
                    status: status,
                    skins: skins ?? []
                )
            )
        )
    }
}

struct ServerSystemTile: Widget {
    let kind: String = "ServerSystemTile"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: MinecraftServerAppIntent.self, provider: Provider()) { entry in
            Group {
                switch entry {
                case .success(let success):
                    ServerListTileContent(
                        server: success.server,
                        status: success.status,
                        lastUpdate: success.date,
                        skins: success.skins
                    )
                case .error(let error):
                    ErrorWidgetView(entry: error)
                }
            }
            .containerBackground(.fill, for: .widget)
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
            Group {
                switch entry {
                case .success(let success):
                    ServerAccessoryRectangular(
                        server: success.server,
                        status: success.status,
                        lastUpdate: success.date,
                        skins: success.skins
                    )
                case .error(let error):
                    ErrorWidgetView(entry: error)
                }
            }
            .containerBackground(.fill, for: .widget)
            .modelContainer(for: MinecraftServer.self)
        }
        .supportedFamilies([.accessoryRectangular])
    }
}
