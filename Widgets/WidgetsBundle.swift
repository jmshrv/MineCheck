//
//  WidgetsBundle.swift
//  Widgets
//
//  Created by James on 04/07/2024.
//

import WidgetKit
import SwiftUI

@main
struct WidgetsBundle: WidgetBundle {
    var body: some Widget {
        ServerSystemTile()
        #if !os(macOS)
        ServerAccessoryRectangularWidget()
        #endif
    }
}
