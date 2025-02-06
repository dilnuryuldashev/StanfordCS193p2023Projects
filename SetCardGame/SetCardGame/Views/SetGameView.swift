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
                            shapeView(shape: card.content.shape, color: card.content.color, shading: card.content.shading)
                                .frame(width: geometry.size.height/3.5, height: geometry.size.width/3.5)
                                .padding(3)
                        }
                        
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }
                
                
            }
            // TODO: this code was for hiding the cards
            // We really need to delete them from the deck now, not just hide
            //.opacity(card.isChosen ? 1 : 0)
            
            base.fill().opacity(card.isChosen ? 0.4 : 0)
        }
        .opacity(card.isChosen || !card.isMatched ? 1 : 0)
    }
    
    func getOpacity(_ shading: CardContent.Shading) -> Double {
        var opacity = 1.0
        switch shading {
        case .empty:
            opacity = 0
        case .full:
            opacity = 1
        case .striped:
            opacity = 0.2
        }
        return opacity
    }
    
    
    @ViewBuilder
    func shapeView(shape: CardContent.ShapeType, color: Color, shading: CardContent.Shading) -> some View {
        let strokeWidth = CGFloat(2)
            switch shape {
            case .diamond:
                Rectangle()
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(color)
                    .opacity(getOpacity(shading))
                    .overlay(Rectangle().stroke(color, lineWidth: strokeWidth))
                    .rotationEffect(Angle.degrees(45))

            case .oval:
                Ellipse()
                    .foregroundStyle(color)
                    .opacity(getOpacity(shading))
                    .overlay(Ellipse().stroke(color, lineWidth: strokeWidth))

            case .squiggle:
                Circle()
                    .foregroundStyle(color)
                    .opacity(getOpacity(shading))
                    .overlay(Circle().stroke(color, lineWidth: strokeWidth))

            }
            
        }
}

#Preview {
    SetGameView(viewModel: SetGameViewModel())
}
