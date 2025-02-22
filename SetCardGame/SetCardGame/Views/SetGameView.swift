//
//  SetGameView.swift
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
    enum Constants {
        static let aspectRatio = CGFloat(3) / CGFloat(2)
        static let spacing: CGFloat = 4
        static let dealAnimation: Animation = .easeInOut(duration: 1)
        static let dealInterval: TimeInterval = 0.15
        static let deckWidth: CGFloat = 50
    }

    @ObservedObject var viewModel: SetGameViewModel
    @Namespace private var dealingNamespace
    typealias Card = SetGame<CardContent>.Card
    
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
            deck.foregroundColor(.cyan)

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
                withAnimation(.bouncy(duration: 1)) {
                    viewModel.shuffleCardsInPlay()
                }
            }
            .setGameButtonStyle()

            discardedPile.foregroundColor(.red)
        }
        .padding()
    }

    private var cards: some View {
        AspectVGrid(viewModel.cardsInPlay, aspectRatio: Constants.aspectRatio) { card in
            if isDealt(card) {
                view(for: card)
                    .padding(Constants.spacing)
//                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
//                    .zIndex(scoreChange(causedBy: card) != 0 ? 100 : 0)
                    .onTapGesture {
                        withAnimation {
                            viewModel.chooseCard(card)
                            discard()
                        }
                    }
            }
        }
    }

    // MARK: - Dealing from a Deck

    @State private var dealt = Set<Card.ID>()
    @State private var discarded = Set<Card.ID>()

    private func isDiscarded(_ card: Card) -> Bool {
        discarded.contains(card.id)
    }


    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }

    private var undealtCards: [Card] {
        viewModel.cards.filter { !isDealt($0) }
    }

    private var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                view(for: card)
            }
        }
        .frame(width: Constants.deckWidth, height: Constants.deckWidth / Constants.aspectRatio)
        .onTapGesture {
            deal()
        }
    }

    private var discardedPile: some View {
        ZStack {
            ForEach(viewModel.discardedCardsArray) { card in
                view(for: card)
            }
        }
        .frame(width: Constants.deckWidth, height: Constants.deckWidth / Constants.aspectRatio)
    }

    private func deal() {
        var delay: TimeInterval = 0
        if !dealt.isEmpty {
            // not a new game
            // so we need to deal three cards
            // this updates cardsInPlay
            // and then we animatedly
            // add it to the visible cards tray
            viewModel.dealThreeCards()
        }

        for card in viewModel.cardsInPlay {
            if !isDealt(card) {
                withAnimation(Constants.dealAnimation.delay(delay)) {
                    _ = dealt.insert(card.id)
                }

                delay += Constants.dealInterval
            }
        }
    }

    private func discard() {
        var delay: TimeInterval = 0
        for card in viewModel.cardsInPlay {
            if viewModel.discardedCardIDs.contains(card.id) {
               _ = withAnimation(Constants.dealAnimation.delay(delay)) {
                    dealt.remove(card.id)
                }
                
                delay += Constants.dealInterval

                _ = withAnimation(Constants.dealAnimation.delay(delay)) {
                    discarded.insert(card.id)
                }
                
                delay += Constants.dealInterval
            }
        }
    }

    private func view(for card: Card) -> some View {
        CardView(card)
            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
//            .transition(.asymmetric(
//                insertion: .opacity,
//                removal: .move(edge: .bottom)
//            ))
    }
}

#Preview {
    SetGameView(viewModel: SetGameViewModel())
}
