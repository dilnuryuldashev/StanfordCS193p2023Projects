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
            Text("Memorize!")
                .font(.largeTitle)
            
            ScrollView {
                cards
                    .animation(.default, value: viewModel.cards)
            }
            
            //Spacer()
            
            Button("Shuffle") {
                viewModel.shuffle()
                print(viewModel.cards)
            }
        }
        .padding()

    }
    
//    var themeButtons: some View {
//        HStack(alignment: .lastTextBaseline) {
//            Button {
//                emojis = sportsThemeEmojis.shuffled()
//            } label: {
//                VStack {
//                    Image(systemName: "figure.badminton")
//                    Text("Sports")
//                        .font(.caption)
//                }
//            }
//            .padding(.horizontal)
//
//            Button {
//                emojis = movieThemeEmojis.shuffled()
//            } label: {
//                VStack {
//                    Image(systemName: "popcorn")
//                    Text("Movies")
//                        .font(.caption)
//                }
//            }
//            .padding(.horizontal)
//
//            Button {
//                emojis = foodThemeEmojis.shuffled()
//            } label: {
//                VStack {
//                    Image(systemName: "fork.knife")
//                    Text("Food")
//                        .font(.caption)
//                }
//            }
//            .padding(.horizontal)
//        }
//    }
    
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
