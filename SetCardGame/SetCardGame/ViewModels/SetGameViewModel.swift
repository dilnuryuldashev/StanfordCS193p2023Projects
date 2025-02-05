//
//  SetGameViewModel.swift
//  SetCardGame
//
//  Created by Dilnur Yuldashev on 2/3/25.
//

import Foundation
import SwiftUI

/**
 In the game, certain combinations of three cards are said to make up a "set". For each one of the four categories of features—color, number, shape, and shading—the three cards must display that feature as either a) all the same, or b) all different. Put another way: For each feature the three cards must avoid having two cards showing one version of the feature and the remaining card showing a different version.
 */


struct CardContent: Equatable {
    static let colorOptions = [Color.red, Color.green, Color.purple]
    static let numberOptions = [1, 2, 3]

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
    private let visibleCardsCount = 12
    /**
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
        return SetGame<CardContent>(cards: cards)
    }
    
    @Published private var model: SetGame<CardContent>

    
    init() {
        let cards = SetGameViewModel.createCards()
        model = SetGameViewModel.createSetGame(cards)
        shuffle()
    }
    
    var cards: [SetGame<CardContent>.Card] {
        model.cards
    }
    
    var visibleCards: [SetGame<CardContent>.Card] {
        Array(cards.shuffled()[0..<visibleCardsCount])
    }
    
    func chooseCard(_ card: SetGame<CardContent>.Card) {
        model.chooseCard(card: card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func newGame() {
        let cards = SetGameViewModel.createCards()
        model = SetGameViewModel.createSetGame(cards)
        shuffle()
    }
}
