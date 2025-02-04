//
//  SetGame.swift
//  SetCardGame
//
//  Created by Dilnur Yuldashev on 2/3/25.
//


import Foundation

struct SetGame<CardContent> {
    private(set) var cards: [SetGame.Card]
    
    init(cards: [SetGame.Card]) {
        self.cards = cards
    }
    
    
    
    struct Card: Identifiable {
        var id: UUID = UUID()
        var content: CardContent
        var isMatched: Bool = false
        var isFaceUp: Bool = true
    }
    
}
