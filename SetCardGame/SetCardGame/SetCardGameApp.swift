//
//  SetCardGameApp.swift
//  SetCardGame
//
//  Created by Dilnur Yuldashev on 2/3/25.
//

import SwiftUI

@main
struct SetCardGameApp: App {
    @StateObject var game = SetGameViewModel()

    var body: some Scene {
        WindowGroup {
            SetGameView(viewModel: game)
        }
    }
}
