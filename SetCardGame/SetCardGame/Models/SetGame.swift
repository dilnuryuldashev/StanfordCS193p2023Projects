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

struct SetGame<CardContent: Equatable & Hashable> {
    private(set) var score: Int
    private(set) var cards: Array<Card>
    private(set) var discardedCards: Array<Card> = []

    private(set) var chosenCardIds: Array<String> = []
    private(set) var dealtCards: Set<Card.ID> = []
    private(set) var discardedCardIDs: Set<Card.ID> = []

    private let isSet: (CardContent, CardContent, CardContent) -> Bool
    
    let originalCardsInPlayCount: Int
    let maxCardsInPlay: Int
    
    private var cheatTrioIDs: [String]
    
    private var numberOfDealtCards: Int {
        dealtCards.count
    }

    init(_ cards: [SetGame.Card], _ cardsInPlay: Int, _ maxCardsInPlay: Int, _ isSet: @escaping (CardContent, CardContent, CardContent) -> Bool) {
        self.cards = cards
        self.originalCardsInPlayCount = cardsInPlay
        self.isSet = isSet
        score = 0
        self.maxCardsInPlay = maxCardsInPlay
        self.cheatTrioIDs = []
    }
    
    
    // Shuffle the whole deck
    mutating func shuffle() {
        cards.shuffle()
    }
    
    var dealtCardsArray: Array<Card> {
        cards.filter {
            dealtCards.contains($0.id)
        }
    }
    
    var discardedCardsArray: Array<Card> {
        cards.filter {
            discardedCardIDs.contains($0.id)
        }
    }
    
    
    // Only shuffle the visible cards
    mutating func shuffleDealtCards() {
        // shuffle the visible cards
        let shuffledDealtCards = dealtCardsArray.shuffled()

        // now apply the shuffled version to the overall deck
        for i in 0..<numberOfDealtCards {
            if let originalIndex = getCardIndex(id: dealtCardsArray[i].id), let newIndex =  getCardIndex(id: shuffledDealtCards[i].id){ // find dealt card's index in the cards
                cards.swapAt(originalIndex, newIndex)
            }
        }
    }
    
    mutating func resetCheatTrioIDs() {
        for id in cheatTrioIDs {
            setHintState(id, false)
        }
    }
    
    // return three distinct card IDs forming a SET to the user
    mutating func cheat() {
        // We don't want the previously chosen cards interferring with the hinting process
        resetChosenCards()
        
        for i in 0..<numberOfDealtCards {
            for j in i+1..<numberOfDealtCards {
                for k in j+1..<numberOfDealtCards {
                    if i != j && i != k && j != k && isSet(cards[i].content, cards[j].content, cards[k].content) {
                        // only show one SET
                        cheatTrioIDs = [cards[i].id, cards[j].id, cards[k].id]
                        cards[i].isHinted = true
                        cards[j].isHinted = true
                        cards[k].isHinted = true
                        return
                    }
                }
            }
        }
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
    mutating func dealNewGame() {
        if cards.count > numberOfDealtCards {
            // There are numberOfDealtCards visible cards
            // so the starting index from which we start
            // adding cards is numberOfDealtCards
            var i = numberOfDealtCards
            
            for _ in 0..<originalCardsInPlayCount {
                dealtCards.insert(cards[i].id)
                i += 1
            }
        }
    }
    
    // When players cannot find a set
    // they have an option of dealing three more cards
    mutating func dealThreeCards() {
        if cards.count > numberOfDealtCards && numberOfDealtCards < maxCardsInPlay { // should not exceed the max number of dealt cards
            // There are numberOfDealtCards visible cards
            // so the starting index from which we start
            // adding cards is numberOfDealtCards
            var i = numberOfDealtCards
            
            for _ in 0..<3 {
                dealtCards.insert(cards[i].id)
                i += 1
            }
        }
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
        for id in chosenCardIds {
            if let index = cards.firstIndex(where: {$0.id == id}){
                // remove the card
                discardedCards.append(cards[index])
                cards.remove(at: index)
            }
            
            discardedCardIDs.insert(id)
            dealtCards.remove(id)
        }
        
        print("model discarded = \(discardedCardIDs.count)")
        print("model dealt = \(dealtCards.count)")

        // Empty the array as we will chose new cards
        chosenCardIds.removeAll()
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
    
    struct Card: Identifiable, Equatable, Hashable {
        var id: String
        var content: CardContent
        var isHinted: Bool = false
        var isChosen: Bool = false
        var isInMatchingSet: Bool = false
        var isInNonMatchingSet: Bool = false
    }
}
