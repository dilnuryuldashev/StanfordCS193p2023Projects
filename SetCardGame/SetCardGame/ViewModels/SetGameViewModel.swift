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


struct CardContent {
    enum Shading {
        case striped,
        full,
        empty
    }
    
    var color: Color
    var shape: any Shape
    var shading: Shading
    var number: Int
    
}

class SetGameViewModel: ObservableObject {
    static var tempCards = [SetGame<CardContent>.Card(content: CardContent(color: .red, shape: Rectangle(), shading: .empty, number: 3)), SetGame<CardContent>.Card(content: CardContent(color: .red, shape: Rectangle(), shading: .empty, number: 3)), SetGame<CardContent>.Card(content: CardContent(color: .red, shape: Rectangle(), shading: .empty, number: 3)), SetGame<CardContent>.Card(content: CardContent(color: .red, shape: Rectangle(), shading: .empty, number: 3)), SetGame<CardContent>.Card(content: CardContent(color: .red, shape: Rectangle(), shading: .empty, number: 3)), SetGame<CardContent>.Card(content: CardContent(color: .red, shape: Rectangle(), shading: .empty, number: 3)), SetGame<CardContent>.Card(content: CardContent(color: .red, shape: Rectangle(), shading: .empty, number: 3)), SetGame<CardContent>.Card(content: CardContent(color: .red, shape: Rectangle(), shading: .empty, number: 3)), SetGame<CardContent>.Card(content: CardContent(color: .red, shape: Rectangle(), shading: .empty, number: 3)), SetGame<CardContent>.Card(content: CardContent(color: .red, shape: Rectangle(), shading: .empty, number: 3)), SetGame<CardContent>.Card(content: CardContent(color: .red, shape: Rectangle(), shading: .empty, number: 3)), SetGame<CardContent>.Card(content: CardContent(color: .red, shape: Rectangle(), shading: .empty, number: 3))
    ]
    
    static func createSetGame() -> SetGame<CardContent> {
        return SetGame<CardContent>(cards: tempCards)
    }
    @Published private var model: SetGame<CardContent>?
    
    init() {
        self.model = SetGameViewModel.createSetGame()
    }
    
    var cards: [SetGame<CardContent>.Card] {
        model?.cards ?? []
    }
    
    
    
}
