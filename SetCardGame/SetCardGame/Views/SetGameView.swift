//
//  ContentView.swift
//  SetCardGame
//
//  Created by Dilnur Yuldashev on 2/3/25.
//

import SwiftUI

struct SetGameButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .foregroundStyle(.white)
    }
}

extension View {
    func setGameButtonStyle() -> some View {
        modifier(SetGameButtonStyle())
    }
}

struct SetGameView: View {
    struct Constants {
        static let aspectRatio = CGFloat(3) / CGFloat(2)
    }
    @ObservedObject var viewModel: SetGameViewModel
    @Namespace private var dealingNamespace
    var body: some View {
        VStack {
            info
            cards
                .padding()
            Spacer()
            buttons
        }
    }
    
    var info: some View {
        HStack {
            Text("Score: \(viewModel.score)")
                .font(.title2)
                .padding()
            Spacer()
            Text("Deck: \(viewModel.deckSize) cards")
                .font(.title2)
                .padding()
        }
        .padding()
    }
    

    
    var buttons: some View {
        HStack {
            Button("Deck") {
                viewModel.dealThreeCards()
            }
            .setGameButtonStyle()
            .disabled(!viewModel.canDealThreeCards)
            .opacity(!viewModel.canDealThreeCards ? 0.5 : 1)


            Button("New Game") {
                withAnimation {
                    viewModel.newGame()
                }
            }
            .setGameButtonStyle()

            
            Button("Cheat") {
                viewModel.cheat()
            }
            .setGameButtonStyle()

            
            Button("Shuffle") {
                withAnimation {
                    viewModel.shuffleCardsInPlay()
                }
            }
            .setGameButtonStyle()

        }
        .padding()
    }
    
    private var cards: some View {
        AspectVGrid(viewModel.cardsInPlay, aspectRatio: Constants.aspectRatio) { card in
            CardView(card)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .transition(.asymmetric(insertion: .identity, removal: .identity))
                //.aspectRatio(3/2, contentMode: .fit)
                .padding(4)
                .onTapGesture {
                    withAnimation {
                        viewModel.chooseCard(card)
                    }
                }
        }
    }
//    
//    private func view(for card: Card) -> some View {
//        CardView(card)
//            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
//            .transition(.asymmetric(insertion: .identity, removal: .identity))
//    }
    

    
//    var cards: some View {
//        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 0)]) {
//            ForEach(viewModel.cardsInPlay) { card in
//                CardView(card)
//                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
//                    .transition(.asymmetric(insertion: .identity, removal: .identity))
//                    .aspectRatio(3/2, contentMode: .fit)
//                    .padding(4)
//                    .onTapGesture {
//                        withAnimation {
//                            viewModel.chooseCard(card)
//                        }
//                    }
//            }
//        }
//        .foregroundStyle(.blue)
//
//    }
    
    
}

#Preview {
    SetGameView(viewModel: SetGameViewModel())
}
