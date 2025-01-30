//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Dilnur Yuldashev on 1/15/25.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
