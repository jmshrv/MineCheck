//
//  PlayerSkin.swift
//  MineCheck
//
//  Created by James on 01/08/2024.
//

import SwiftUI

struct PlayerSkin: View {
    let skinData: Data?
    
    var body: some View {
        image
            .interpolation(.none)
            .offset(x: -8, y: -8)
            .frame(width: 8, height: 8, alignment: .topLeading)
            .clipped()
    }
    
    var image: Image {
        if let skinData {
            #if canImport(UIKit)
            if let uiImage = UIImage(data: skinData) {
                Image(uiImage: uiImage)
            } else {
                Image(.steve)
            }
            #elseif canImport(AppKit)
            if let nsImage = NSImage(data: skinData) {
                Image(nsImage: nsImage)
            } else {
                Image(.steve)
            }
            #else
            Image(.steve)
            #endif
        } else {
            Image(.steve)
        }
    }
}

#Preview {
    PlayerSkin(skinData: nil)
        .frame(width: 400, height: 400)
}
