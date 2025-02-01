//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Dilnur Yuldashev on 1/15/25.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Text(viewModel.nameOfTheme)
                .font(.largeTitle)
            
            ScrollView {
                cards
                    .animation(.default, value: viewModel.cards)
            }
            
            //Spacer()
            HStack {
                Button("Shuffle") {
                    viewModel.shuffle()
                    print(viewModel.cards)
                }
                .padding()
                .background(.indigo)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                
                Button("New Game") {
                    viewModel.newGame()
                }
                .padding()
                .background(.indigo)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .foregroundStyle(.white)
        }
        
        .padding()

    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)]) {
            ForEach(viewModel.cards) { card in
                CardView(card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
        }
        .foregroundStyle(.orange)
    }
    
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base
                    .strokeBorder(lineWidth: 2)
                Text(card.content)
                    .font(.system(size: 200))
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
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
