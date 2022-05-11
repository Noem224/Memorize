//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Daniel Wippermann on 28.04.22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject private var viewModel = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
