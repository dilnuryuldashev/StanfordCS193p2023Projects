//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Dilnur Yuldashev on 1/29/25.
//

import Foundation

struct MemoryGame<CardContent> {
    var cards: Array<Card>
    
    func choose(card: Card) {
        
    }
    
    struct Card{
        var isFaceUp: Bool
        var isMatched: Bool
        var content: CardContent
    }
}
