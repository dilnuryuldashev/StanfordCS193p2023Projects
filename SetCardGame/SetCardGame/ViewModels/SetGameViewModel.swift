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



struct CardContent: Equatable {
    static let colorOptions = [Color.red, Color.green, Color.purple]
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

    
    init() {
        let cards = SetGameViewModel.createCards()
        model = SetGameViewModel.createSetGame(cards)
        shuffle()
    }
    
    var cardsInPlay: [SetGame<CardContent>.Card] {
        model.cardsToShow
    }
    
    var score: Int {
        model.score
    }
    
    func chooseCard(_ card: SetGame<CardContent>.Card) {
        model.chooseCard(card: card)
    }
    
    // Show one SET forming three cards for one second
    // and then reset their states
    func cheat() {
        let (i, j, k) = model.getSetFormingTripleIDs()
        
        Task {
            model.setHintState(i, true)
            model.setHintState(j, true)
            model.setHintState(k, true)

            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            model.setHintState(i, false)
            model.setHintState(j, false)
            model.setHintState(k, false)
        }
    }
    
    var deckSize: Int {
        model.cards.count
    }
    
    var canDealThreeCards: Bool {
        model.cardsToShow.count < SetGameViewModel.maxVisibleCardsCount
    }
    
    func dealThreeCards() {
        model.dealThreeCards()
    }
    
    private func shuffle() {
        model.shuffle()
    }
    
    func newGame() {
        let cards = SetGameViewModel.createCards()
        model = SetGameViewModel.createSetGame(cards)
        shuffle()
    }
}
