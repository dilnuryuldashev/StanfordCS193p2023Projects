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
            
            Text("Score: \(viewModel.score)")
                .font(.title)
                .padding()
            cards
                .animation(.default, value: viewModel.cardsInPlay)
                .padding()
            
            Spacer()

            
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
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 0)]) {
            ForEach(viewModel.cardsInPlay) { card in
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
                GeometryReader { geometry in
                    HStack(spacing: 8) {
                        ForEach(1...(card.content.number), id: \.self) {_ in
                            // TODO: properly draw the shapes
                            shapeView(for: card.content.shape, color: card.content.color)
                                .frame(width: geometry.size.height/3.5, height: geometry.size.width/3.5)
                                .padding(3)
                        }
                        
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
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
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(color)
                    .rotationEffect(Angle.degrees(45))

            case .oval:
                Ellipse()
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
