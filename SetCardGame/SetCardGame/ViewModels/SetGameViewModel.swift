//
//  SetGameViewModel.swift
//  SetCardGame
//
//  Created by Dilnur Yuldashev on 2/3/25.
//

import Foundation
import SwiftUI

/**
 Source: Wikipedia
 In the game, certain combinations of three cards are said to make up a "set". For each one of the four categories of features—color, number, shape, and shading—the three cards must display that feature as either a) all the same, or b) all different. Put another way: For each feature the three cards must avoid having two cards showing one version of the feature and the remaining card showing a different version.
 */



struct CardContent: Equatable, Hashable {
    static let correctColor = Color.green
    static let incorrectColor = Color.red
    static let colorOptions = [Color.indigo, Color.orange, Color.teal]
    static let numberOptions = [1, 2, 3]
    
    // we need three way comparison
    // set = features all same or all different
    static func isSet (_ first: CardContent, _ second: CardContent, _ third: CardContent) -> Bool {
        return ((first.color != second.color && first.color != third.color && second.color != third.color) ||
        (first.color == second.color && first.color == third.color)) &&
        ((first.number != second.number && first.number != third.number && second.number != third.number) ||
        (first.number == second.number && first.number == third.number)) &&
        ((first.shape != second.shape && first.shape != third.shape && second.shape != third.shape) ||
        (first.shape == second.shape && first.shape == third.shape)) &&
        ((first.shading != second.shading && first.shading != third.shading && second.shading != third.shading) ||
        (first.shading == second.shading && first.shading == third.shading))
    }

    enum Shading: CaseIterable {
        case striped,
        full,
        empty
    }
    
    enum ShapeType: CaseIterable {
        case diamond
        case oval
        case squiggle
    }
    

    var color: Color
    var shape: ShapeType
    var shading: Shading
    var number: Int
    
}

class SetGameViewModel: ObservableObject {
    private static let visibleCardsCount = 12
    private static let maxVisibleCardsCount = 18 // no more dealing after this point
    private let nanosecondsToWait: UInt64 = 5_000_000_00
    /**
     Source: Wikipedia
     The deck consists of 81 unique cards that vary in four features across three possibilities for each kind of feature:
     number of shapes (one, two, or three),
     shape (diamond, squiggle, oval),
     shading (solid, striped, or open), and color (red, green, or purple).
     Each possible combination of features (e.g. a card with three striped green diamonds) appears as a card precisely once in the deck.
     */
    
    // Iterate over all feature possibilities to create the 81 cards
    static func createCards() -> [SetGame<CardContent>.Card] {
        var cards: [SetGame<CardContent>.Card] = []
        for shapeNumber in CardContent.numberOptions {
            for shapeType in CardContent.ShapeType.allCases {
                for shadingType in CardContent.Shading.allCases {
                    for color in CardContent.colorOptions {
                        cards.append(SetGame<CardContent>.Card(id: "\(shapeNumber)\(shapeType)\(shadingType)\(color)", content: CardContent(color: color, shape: shapeType, shading: shadingType, number: shapeNumber)))
                    }
                }
            }
        }
        
        return cards
    }
    
    static func createSetGame(_ cards: [SetGame<CardContent>.Card]) -> SetGame<CardContent> {
        return SetGame<CardContent>(cards, visibleCardsCount, maxVisibleCardsCount, CardContent.isSet(_:_:_:))
    }
    
    @Published private var model: SetGame<CardContent>
    typealias SetCard = SetGame<CardContent>.Card
    
    init() {
        let cards = SetGameViewModel.createCards()
        model = SetGameViewModel.createSetGame(cards)
        shuffle()
        model.dealNewGame()
    }
    
    var cardsInPlay: [SetGame<CardContent>.Card] {
        model.dealtCardsArray
    }
    
    var discardedCardsArray: [SetGame<CardContent>.Card] {
        model.discardedCards
    }
    
    var discardedCardIDs: Set<String> {
        model.discardedCardIDs
    }
    
    var cards: [SetGame<CardContent>.Card] {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    func setMatchingStateOfChosenCards(_ state: Bool) {
        model.setMatchingStateOfChosenCards(state)
    }
    
    func setNonMatchingStateOfChosenCards(_ state: Bool) {
        model.setNonMatchingStateOfChosenCards(state)
    }
    
    func deleteChosenCards() {
        model.deleteChosenCards()
    }
    
    func resetChosenCards() {
        model.resetChosenCards()
    }
    
    func setCardFaceUpState(_ card: SetCard, _ state: Bool) {
        model.setCardFaceUpState(card, state)
    }
    
    func chooseCard(_ card: SetCard) -> MatchResult {
        if model.chosenCardIds.count != 3 { // we are adding one more card here
            // we get back a function to execute after showing
            // the user if it was a set or not
            let result: MatchResult = model.chooseCard(card: card)
            if result == .matched {
                return .matched
            } else if result == .notAMatch {
                return .notAMatch

            }
        }
        
        return .lessThanThreeCardsChosen
    }
    
    // Select one SET forming three cards
    func cheat() {
        model.cheat()
    }
    
    func resetCheating() {
        model.resetCheatTrioIDs()
    }
    
    var deckSize: Int {
        model.cards.count
    }
    
    var canDealThreeCards: Bool {
        model.dealtCards.count < SetGameViewModel.maxVisibleCardsCount
    }
    
    func dealThreeCards() {
        model.dealThreeCards()
    }
    
    private func shuffle() {
        model.shuffle()
    }
    
    func shuffleCardsInPlay(){
        model.shuffleDealtCards()
    }
    
    func newGame() {
        let cards = SetGameViewModel.createCards()
        model = SetGameViewModel.createSetGame(cards)
        shuffle()
        model.dealNewGame()
    }
}
