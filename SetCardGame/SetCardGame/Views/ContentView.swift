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
            
            VStack {
                cards
                
            }
            .foregroundStyle(.blue)
            .padding()
        }
        .ignoresSafeArea()
    }
    
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: 2.0/3.0) { card in
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
                Text(card.content.color.description)
                    .font(.system(size: 200))
                    .foregroundStyle(.black)
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
                
            }
            .opacity(card.isFaceUp ? 1 : 0)
            
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
    
}

#Preview {
    ContentView()
}
