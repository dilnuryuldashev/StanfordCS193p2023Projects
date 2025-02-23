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
            .background(.cyan)
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
        static let deckWidth: CGFloat = 80

        enum Hint {
            static let showHideDuration: TimeInterval = 0.5
            static let delay: TimeInterval = 0.5
        }

        enum CardChoice {
            static let showHideDuration: TimeInterval = 0.5
            static let delay: TimeInterval = 0.5
        }
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
            undealtAndDiscarded
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

    var undealtAndDiscarded: some View {
        HStack {
            deck
                .padding(.horizontal)
            
            if !viewModel.discardedCardsArray.isEmpty {
                discardedPile
                    .padding(.horizontal)
            }
        }
    }

    private func cheat() {
        withAnimation(.easeIn(duration: Constants.Hint.showHideDuration)) {
            viewModel.cheat()
        }

        withAnimation(.easeOut(duration: Constants.Hint.showHideDuration).delay(Constants.Hint.delay)) {
            viewModel.resetCheating()
        }
    }

    var buttons: some View {
        HStack {
            Button("Cheat") {
                cheat()
            }
            .setGameButtonStyle()

            Button("New Game") {
                withAnimation {
                    discarded.removeAll()
                    dealt.removeAll()
                    viewModel.newGame()
                }
            }
            .setGameButtonStyle()

            Button("Shuffle") {
                withAnimation(.bouncy(duration: 1)) {
                    viewModel.shuffleCardsInPlay()
                }
            }
            .setGameButtonStyle()
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
                        handleCardSelection(card)
                    }
            }
        }
    }

    private func handleCardSelection(_ card: Card) {
        let result = viewModel.chooseCard(card)

        switch result {
        case .matched:
            // light them all green
            // and after one second, remove them from the deck
            withAnimation(.easeIn(duration: Constants.CardChoice.showHideDuration)) {
                viewModel.setMatchingStateOfChosenCards(true)
            }

            withAnimation(.easeOut(duration: Constants.CardChoice.showHideDuration).delay(Constants.CardChoice.delay)) {
                viewModel.setMatchingStateOfChosenCards(false)
                viewModel.deleteChosenCards()
            }

            withAnimation(.easeOut(duration: Constants.CardChoice.showHideDuration).delay(2 * Constants.CardChoice.delay)) {
                discard()
            }
        case .notAMatch:
            withAnimation(.easeIn(duration: Constants.CardChoice.showHideDuration)) {
                viewModel.setNonMatchingStateOfChosenCards(true)
            }

            withAnimation(.easeOut(duration: Constants.CardChoice.showHideDuration).delay(Constants.CardChoice.delay)) {
                viewModel.setNonMatchingStateOfChosenCards(false)
                viewModel.resetChosenCards()
            }
        case .lessThanThreeCardsChosen:
            break
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
            ForEach(Array(undealtCards.prefix(3).enumerated()), id: \.element.id) { index, card in
                view(for: card)
                    .rotationEffect(.degrees(degreeBasedOnIndex(index)))
                    .offset(offsetBasedOnIndex(index))
            }
        }
        .frame(width: Constants.deckWidth, height: Constants.deckWidth / Constants.aspectRatio)
        .onTapGesture {
            deal()
        }
    }
    
    private func degreeBasedOnIndex(_ index: Int) -> Double {
        -10 + Double(index) * 10
    }
    
    private func offsetBasedOnIndex(_ index: Int) -> CGSize{
        CGSize(width: (-10 + Double(index) * 10), height: Double(0))
    }

    private var discardedPile: some View {
        ZStack {
            ForEach(Array(viewModel.discardedCardsArray.prefix(3).enumerated()), id: \.element.id) { index, card in
                view(for: card)
                    .rotationEffect(.degrees(degreeBasedOnIndex(index)))
                    .offset(offsetBasedOnIndex(index))
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
                    viewModel.setCardFaceUpState(card, true)
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
