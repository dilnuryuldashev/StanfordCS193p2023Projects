//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Dilnur Yuldashev on 1/29/25.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    private let themes = [
        Theme(name: "Sports", emojis: ["⚽️", "🏀", "🏈", "🎾", "⚾️", "🏆"], numberOfPairsToShow: 3, colorString: "blue"),
        Theme(name: "Food", emojis: ["🍎", "🍊", "🍋", "🍌", "🍉", "🍇"], numberOfPairsToShow: 4, colorString: "orange"),
        Theme(name: "Flags", emojis: ["🇫🇷", "🇩🇪", "🇮🇹", "🇪🇸", "🇺🇸", "🇧🇷"], numberOfPairsToShow: 6, colorString: "green"),
        Theme(name: "Animals", emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🐻"], numberOfPairsToShow: 3, colorString: "red"),
        Theme(name: "Transportation", emojis: ["🚗", "🚀", "🚄", "🚆", "🚂", "🚃"], numberOfPairsToShow: 3, colorString: "yellow"),
        Theme(name: "Activities", emojis: ["🎮", "🎨", "🎭", "🎥", "🎶", "🎤"], numberOfPairsToShow: 3, colorString: "purple")
    ]
    
    private var currentTheme: Theme<String>
    @Published private var model: MemoryGame<String>
    
    init() {
        currentTheme = themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(emojis: currentTheme.emojis)
    }
    
    private static func createMemoryGame(emojis: [String]) -> MemoryGame<String> {
        return MemoryGame(numberOfPairsOfCards: 6) { pairIndex in
            if emojis.indices.contains(pairIndex) {
                return emojis[pairIndex]
            } else {
                return "!?"
            }
        }
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    var nameOfTheme: String {
        return currentTheme.name
    }
    
    // MARK: - Intents
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func newGame() {
        currentTheme = themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(emojis: currentTheme.emojis)
    }
    
    
}
