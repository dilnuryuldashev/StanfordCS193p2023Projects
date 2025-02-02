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
        model = EmojiMemoryGame.createMemoryGame(theme: currentTheme)
        model.shuffle()
    }
    
    private static func createMemoryGame(theme: Theme<String>) -> MemoryGame<String> {
        return MemoryGame(numberOfPairsOfCards: theme.numberOfPairsToShow) { pairIndex in
            var shuffledEmojis = theme.emojis.shuffled()
            if shuffledEmojis.indices.contains(pairIndex) {
                return shuffledEmojis[pairIndex]
            } else {
                return "!?"
            }
        }
    }
    
    var score: Int {
        model.getScore()
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    var nameOfTheme: String {
        return currentTheme.name
    }
    
    var themeColor: Color {
        switch currentTheme.colorString {
        case "orange":
            return .orange
        case "green":
            return .green
        case "red":
            return .red
        case "yellow":
            return .yellow
        case "purple":
            return .purple
        default:
            return .blue
        }
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
        model = EmojiMemoryGame.createMemoryGame(theme: currentTheme)
        model.shuffle()
    }
    
    
}
