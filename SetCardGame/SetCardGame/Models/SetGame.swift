//
//  SetGame.swift
//  SetCardGame
//
//  Created by Dilnur Yuldashev on 2/3/25.
//


import Foundation

struct SetGame<CardContent: Equatable> {
    private(set) var cards: Array<Card>
    
    init(cards: [SetGame.Card]) {
        self.cards = cards
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func chooseCard(card: Card) {
        let chosenCardIndex: Int? = cards.firstIndex(of: card)
        
        if let chosenCardIndex {
            cards[chosenCardIndex].isFaceUp.toggle()
        }
    }
    
    struct Card: Identifiable, Equatable {
        var id: String
        var content: CardContent
        var isMatched: Bool = false
        var isFaceUp: Bool = true
    }
}
