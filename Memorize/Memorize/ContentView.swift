//
//  ContentView.swift
//  Memorize
//
//  Created by Dilnur Yuldashev on 1/15/25.
//

import SwiftUI

struct ContentView: View {
    let sportsThemeEmojis = ["⚽️", "🏀", "🏈", "🥎", "⚽️", "🏀", "🏈", "🥎", "⚽️", "🏀", "🏈", "🥎", "⚽️", "🏀", "🏈", "🥎"]
    let foodThemeEmojis = ["🍎", "🍌", "🍊", "🍋", "🍎", "🍌", "🍊", "🍋", "🍎", "🍌", "🍊", "🍋", "🍎", "🍌", "🍊", "🍋"]
    let movieThemeEmojis = ["🎬", "🎥", "🎞️", "🎟️", "🎬", "🎥", "🎞️", "🎟️", "🎬", "🎥", "🎞️", "🎟️", "🎬", "🎥", "🎞️", "🎟️"]
    @State var emojis: Array<String> = []
    //@State var cardCount = 4
    
    var body: some View {
        VStack {
            Text("Memorize!")
                .font(.largeTitle)
            
            ScrollView {
                cards
            }
            
            Spacer()
            
            themeButtons
        }
        .padding()

    }
    
    var themeButtons: some View {
        HStack(alignment: .lastTextBaseline) {
            Button {
                emojis = sportsThemeEmojis.shuffled()
            } label: {
                VStack {
                    Image(systemName: "figure.badminton")
                    Text("Sports")
                        .font(.caption)
                }
            }
            .padding(.horizontal)

            Button {
                emojis = movieThemeEmojis.shuffled()
            } label: {
                VStack {
                    Image(systemName: "popcorn")
                    Text("Movies")
                        .font(.caption)
                }
            }
            .padding(.horizontal)

            Button {
                emojis = foodThemeEmojis.shuffled()
            } label: {
                VStack {
                    Image(systemName: "fork.knife")
                    Text("Food")
                        .font(.caption)
                }
            }
            .padding(.horizontal)
        }
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))]) {
            ForEach(0..<emojis.count, id: \.self) { index in
                CardView(content: emojis[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundStyle(.orange)
    }
    
}

struct CardView: View {
    @State var isFaceUp: Bool = false
    let content: String
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base
                    .strokeBorder(lineWidth: 2)
                Text(content).font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            
            base.fill().opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}
    

#Preview {
    ContentView()
}
