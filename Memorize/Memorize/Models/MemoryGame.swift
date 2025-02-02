//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Dilnur Yuldashev on 1/29/25.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private var score: Int
    private(set) var cards: Array<Card>
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        score = 0
        self.cards = []
        // add numberOfPairsOfCards x 2 cards
        
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex)a"))
            cards.append(Card(content: content, id: "\(pairIndex)b"))
        }
    }
    
    func getScore() -> Int {
        score
    }
    
    var indexOfTheOnlyCardFaceUpCard: Int? {
        get {
            cards.indices.filter {
                index in cards[index].isFaceUp
            }
            .only
        }
        
        set {
            return cards.indices.forEach {
                // if the card was face up and now it's flipped
                // then it has already been seen
                if cards[$0].isFaceUp == true && !(newValue == $0) {
                    // car has already been seen
                    cards[$0].alreadySeen = true
                }
                
                cards[$0].isFaceUp = (newValue == $0)
            }
        }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex =  cards.firstIndex(where: { $0.id == card.id }) {
            if !(cards[chosenIndex].isFaceUp || cards[chosenIndex].isMatched) {
                if let potentialMatchIndex = indexOfTheOnlyCardFaceUpCard {
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                        score += 2
                    } else {
                        if cards[chosenIndex].alreadySeen {
                            score -= 1
                        }
                    }
                } else {
                    indexOfTheOnlyCardFaceUpCard = chosenIndex
                }
                
                cards[chosenIndex].isFaceUp = true
            }
        }
    }
    
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var debugDescription: String {
            "\(id): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? "✅" : "X")"
        }
        
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        let content: CardContent
        var alreadySeen: Bool = false
        var id: String
    }
}


extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
