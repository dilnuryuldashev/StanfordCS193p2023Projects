//
//  ContentView.swift
//  SetCardGame
//
//  Created by Dilnur Yuldashev on 2/3/25.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var viewModel: SetGameViewModel
    
    var body: some View {
        VStack {
//            Color.yellow
//                .ignoresSafeArea()
            
            ScrollView {
                cards
                    .animation(.default, value: viewModel.cards)
            }
            .padding()

            
            HStack {
                Button("Shuffle") {
                    viewModel.shuffle()
                }
                .padding(10)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Button("New Game") {
                    viewModel.newGame()
                }
                .padding(10)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .foregroundStyle(.white)
            
            
            .padding()
        }
    }
    

    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 0)]) {
            ForEach(viewModel.cards) { card in
                CardView(card)
                    .aspectRatio(3/2, contentMode: .fit)
                    .padding(4)
                    .onTapGesture {
                        viewModel.chooseCard(card)
                    }
            }
        }
        .foregroundStyle(.blue)

    }
    
    
}

struct CardView: View {
    let card: SetGame<CardContent>.Card
    
    init(_ card: SetGame<CardContent>.Card) {
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
                            .frame(width: 20, height: 20)
                        
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
    SetGameView(viewModel: SetGameViewModel())
}
