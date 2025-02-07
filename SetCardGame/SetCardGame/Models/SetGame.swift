//
//  SetGame.swift
//  SetCardGame
//
//  Created by Dilnur Yuldashev on 2/3/25.
//


import Foundation

enum MatchResult {
    case matched
    case notAMatch
    case lessThanThreeCardsChosen
}

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
    
    // When user finds three cards that form a SET
    private mutating func setMatchingState(_ id: String, _ setState: Bool) {
        let chosenCardIndex = getCardIndex(id: id)
        
        if let chosenCardIndex {
            cards[chosenCardIndex].isInMatchingSet = setState
        }
    }
    
    mutating func setMatchingStateOfChosenCards(_ setState: Bool) {
        for card in cards {
            if card.isChosen {
                setMatchingState(card.id, setState)
            }
        }
    }
    
    mutating func setNonMatchingStateOfChosenCards(_ setState: Bool) {
        for card in cards {
            if card.isChosen {
                setNonMatchingState(card.id, setState)
            }
        }
    }
    
    // When user selects three cards not forming a SET
    private mutating func setNonMatchingState(_ id: String, _ setState: Bool) {
        let chosenCardIndex = getCardIndex(id: id)
        
        if let chosenCardIndex {
            cards[chosenCardIndex].isInNonMatchingSet = setState
        }

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
        if cards.count > currentCardsInPlay {
            currentCardsInPlay += 3
        }
    }
    
    // We only show three more cards after a set
    // if currentCardsInPlay is less than the original
    // number of cards in play
    mutating func showThreeMoreCards() {
        if currentCardsInPlay < originalCardsInPlayCount {
            currentCardsInPlay += 3
        } else if currentCardsInPlay > originalCardsInPlayCount {
            // if we are showing less than originalCardsInPlayCount cards, we fill it to originalCardsInPlayCount
            currentCardsInPlay -= 3
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
        cleanChoosenCards()
    }
    
    private mutating func cleanChoosenCards() {
        chosenCardIds.removeAll()
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
        
        // Empty the array as we will chose new cards
        chosenCardIds.removeAll()
        print("SetGame deleteChosenCards. cards.count: \(cards.count)")
        print("numberOfDeletions: \(numberOfDeletions)")
        // if the set cards are successfully deleted
        // we need to show three more cards to replace them
        if numberOfDeletions == 3 {
            showThreeMoreCards()
            // if the number of cards is less than the current cards in play
            // we just show the remaining cards
            currentCardsInPlay = min(currentCardsInPlay, cards.count)
        }
    }
    
    private func getCardIndex(id: String) -> Int? {
        let chosenCardIndex = cards.firstIndex(where:{ id == $0.id})
        return chosenCardIndex ?? nil
    }
    
    // Return true if there is a SET, and false otherwise
    // and the function to execute for that case
    mutating func chooseCard(card: Card) -> MatchResult {
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
                            return .matched
                        } else {
                            print("SetGame-chooseCard: not a set")
                            // deselect the cards
                            // peanalize for not forming a SET
                            score -= 1
                            return .notAMatch
                            
                        }
                    }

                }
            } else { // deselect the card
                if chosenCardIds.count < 3 {
                    if let index = chosenCardIds.firstIndex(of: cards[chosenCardIndex].id) {
                        chosenCardIds.remove(at: index)
                    }
                }
            }
            
        }
        
        return .lessThanThreeCardsChosen
    }
    
    struct Card: Identifiable, Equatable {
        var id: String
        var content: CardContent
        var isHinted: Bool = false
        var isChosen: Bool = false
        var isInMatchingSet: Bool = false
        var isInNonMatchingSet: Bool = false
    }
}
