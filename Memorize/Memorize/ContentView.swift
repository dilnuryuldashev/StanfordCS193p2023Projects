//
//  ContentView.swift
//  Memorize
//
//  Created by Dilnur Yuldashev on 1/15/25.
//

import SwiftUI

struct ContentView: View {
    let emojis = ["😃", "☹️", "😎", "😂", "😃", "☹️", "😎", "😂"]
    @State var cardCount = 4
    var body: some View {
        VStack {
            ScrollView {
                cards
            }
            Spacer()
            cardCountAdjusters
        }
        .padding()

    }
    
    var cardCountAdjusters: some View {
        HStack {
            cardAdder
            Spacer()
            cardRemover
            
        }
        .font(.largeTitle)
    }
    
    func cardCountAdjuster(by offset: Int, name: String, systemImage: String) -> some View {
        Button(name, systemImage: systemImage, action: {
            cardCount += offset
            
        })
        .disabled(cardCount + offset < 1 || cardCount + offset > emojis.count)

    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
            ForEach(0..<cardCount, id: \.self) { index in
                CardView(content: emojis[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundStyle(.orange)
    }
    
    var cardAdder: some View {
        cardCountAdjuster(by: 1, name: "Add", systemImage: "plus.rectangle.fill")
    }
    
    var cardRemover: some View {
        cardCountAdjuster(by: -1, name: "Remove", systemImage: "minus.rectangle.fill")
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
