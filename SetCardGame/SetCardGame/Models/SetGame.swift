//
//  SetGame.swift
//  SetCardGame
//
//  Created by Dilnur Yuldashev on 2/3/25.
//


import Foundation

struct SetGame<CardContent: Equatable> {
    private(set) var score: Int
    private(set) var cards: Array<Card>
    private(set) var chosenCardIndices: Array<Int> = []
    private let isSet: (CardContent, CardContent, CardContent) -> Bool
    
    var cardsInPlay: Int

    init(_ cards: [SetGame.Card], _ cardsInPlay: Int, _ isSet: @escaping (CardContent, CardContent, CardContent) -> Bool) {
        self.cards = cards
        self.cardsInPlay = cardsInPlay
        self.isSet = isSet
        score = 0
    }
    
    // TODO: shuffle the visible cards
    mutating func shuffle() {
        cards.shuffle()
    }
    
    var cardsToShow: Array<Card> {
        Array(cards[0..<cardsInPlay])
    }
    
    mutating func chooseCard(card: Card) {
        let chosenCardIndex: Int? = cards.firstIndex(of: card)
        
        if let chosenCardIndex {
            cards[chosenCardIndex].isChosen.toggle()
            if cards[chosenCardIndex].isChosen {
                chosenCardIndices.append(chosenCardIndex)
                if chosenCardIndices.count == 3 {
                    if isSet(cards[chosenCardIndices[0]].content, cards[chosenCardIndices[1]].content, cards[chosenCardIndices[2]].content) {
                        print("SetGame-chooseCard: is set!")
                    } else {
                        print("SetGame-chooseCard: not a set")
                    }
                    
                    // Empty the array as we will chose new three cards
                    chosenCardIndices.removeAll()

                }
            }
            
        }
    }
    
    struct Card: Identifiable, Equatable {
        var id: String
        var content: CardContent
        var isMatched: Bool = false
        var isChosen: Bool = false
    }
}
