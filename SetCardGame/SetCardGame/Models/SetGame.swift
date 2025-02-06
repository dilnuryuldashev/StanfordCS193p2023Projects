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
    private(set) var chosenCardIds: Array<String> = []
    private let isSet: (CardContent, CardContent, CardContent) -> Bool
    
    let originalCardsInPlayCount: Int
    let maxCardsInPlay: Int
    
    private var currentCardsInPlay: Int

    init(_ cards: [SetGame.Card], _ cardsInPlay: Int, _ maxCardsInPlay: Int, _ isSet: @escaping (CardContent, CardContent, CardContent) -> Bool) {
        self.cards = cards
        self.originalCardsInPlayCount = cardsInPlay
        self.isSet = isSet
        score = 0
        currentCardsInPlay = cardsInPlay
        self.maxCardsInPlay = maxCardsInPlay
    }
    
    // TODO: shuffle the visible cards
    mutating func shuffle() {
        cards.shuffle()
    }
    
    // return three distinct card IDs forming a SET to the user
    mutating func getSetFormingTripleIDs() -> (String, String, String){
        // We don't want the previously chosen cards interferring with the hinting process
        resetChosenCards()
        
        for i in 0..<currentCardsInPlay {
            for j in i+1..<currentCardsInPlay {
                for k in j+1..<currentCardsInPlay {
                    if i != j && i != k && j != k && isSet(cards[i].content, cards[j].content, cards[k].content) {
                        // only show one SET
                        return (cards[i].id, cards[j].id, cards[k].id)
                    }
                }
            }
        }
        
        // SET not Found
        return ("", "", "")
    }
    
    mutating func setHintState(_ id: String, _ hintState: Bool) {
        let chosenCardIndex = getCardIndex(id: id)
        
        if let chosenCardIndex {
            cards[chosenCardIndex].isHinted = hintState
        }

    }
    
    // When players cannot find a set
    // they have an option of dealing three more cards
    mutating func dealThreeCards() {
        currentCardsInPlay += 3
    }
    
    // We only show three more cards after a set
    // if currentCardsInPlay is less than the original
    // number of cards in play
    mutating func showThreeMoreCards() {
        if currentCardsInPlay < originalCardsInPlayCount {
            currentCardsInPlay += 3
        }
    }
    
    var cardsToShow: Array<Card> {
        Array(cards[0..<currentCardsInPlay])
    }
    
    
    // After user fails to form a SET
    // We need to reset the cards back to their original states
    mutating func resetChosenCards() {
        for id in chosenCardIds {
            let index = getCardIndex(id: id)
            if let index {
                cards[index].isChosen = false
            }
        }
    }
    
    
    // Our deck needs to get smaller until there are no cards left
    // So, when a SET is found, we decrease our deck by 3
    mutating func deleteChosenCards() {
        var numberOfDeletions = 0
        for id in chosenCardIds {
            let index = getCardIndex(id: id)
            if let index {
                cards.remove(at: index)
                numberOfDeletions += 1
            }
        }
        
        
        print("SetGame deleteChosenCards. cards.count: \(cards.count)")
        print("numberOfDeletions: \(numberOfDeletions)")
        // if the set cards are successfully deleted
        // we need to show three more cards to replace them
        if numberOfDeletions == 3 {
            showThreeMoreCards()
        }
    }
    
    private func getCardIndex(id: String) -> Int? {
        let chosenCardIndex = cards.firstIndex(where:{ id == $0.id})
        return chosenCardIndex ?? nil
    }
    
    mutating func chooseCard(card: Card) {
        let chosenCardIndex = getCardIndex(id: card.id)
        
        if let chosenCardIndex {
            cards[chosenCardIndex].isChosen.toggle()
            if cards[chosenCardIndex].isChosen {
                chosenCardIds.append(cards[chosenCardIndex].id)
                if chosenCardIds.count == 3 {
                    if let firstCardIndex = getCardIndex(id: chosenCardIds[0]), let secondIndex = getCardIndex(id: chosenCardIds[1]), let thirdIndex = getCardIndex(id: chosenCardIds[2]) {
                        if isSet(cards[firstCardIndex].content, cards[secondIndex].content, cards[thirdIndex].content) {
                            print("SetGame-chooseCard: is set!")
                            // increase the score as we found a SET
                            score += 1
                            // Delete the cards from the deck
                            deleteChosenCards()
                        } else {
                            print("SetGame-chooseCard: not a set")
                            // deselect the cards
                            resetChosenCards()
                            // peanalize for not forming a SET
                            score -= 1
                        }
                        
                        // Empty the array as we will chose new cards
                        chosenCardIds.removeAll()
                        
                    }
                    

                }
            }
            
        }
    }
    
    struct Card: Identifiable, Equatable {
        var id: String
        var content: CardContent
        var isHinted: Bool = false
        var isChosen: Bool = false
    }
}
