//
//  ContentView.swift
//  SetCardGame
//
//  Created by Dilnur Yuldashev on 2/3/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = SetGameViewModel()
    
    var body: some View {
        ZStack {
            Color.purple
                .ignoresSafeArea()
            
            VStack {
                cards
                
            }
            .foregroundStyle(.blue)
            .padding()
        }
    }
    
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: 3.0/2) { card in
            CardView(card: card)
                .padding(4)
            
        }
    }
    
    
}

struct CardView: View {
    let card: SetGame<CardContent>.Card
    
    init(card: SetGame<CardContent>.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base
                    .strokeBorder(lineWidth: 2)
                HStack {
                    ForEach(1...(card.content.number), id: \.self) {_ in
                        // draw the shape number times
                        shapeView(for: card.content.shape, color: card.content.color)
                        //.fill(card.content.color)
                            .frame(width: 60, height: 60)
                        
                    }
                }
                
            }
            .opacity(card.isFaceUp ? 1 : 0)
            
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
    
    @ViewBuilder
    func shapeView(for shapeType: CardContent.ShapeType, color: Color) -> some View {
            switch shapeType {
            case .diamond:
                Rectangle()
                    .foregroundStyle(color)

            case .oval:
                Capsule(style: .circular)
                    .foregroundStyle(color)

            case .squiggle:
                Circle()
                    .foregroundStyle(color)

            }
        }
}

#Preview {
    ContentView()
}
