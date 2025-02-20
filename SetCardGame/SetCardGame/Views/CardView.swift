//
//  CardView.swift
//  SetCardGame
//
//  Created by Dilnur Yuldashev on 2/20/25.
//

import SwiftUI

struct CardView: View {
    let card: SetGame<CardContent>.Card
    
    init(_ card: SetGame<CardContent>.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                let cardColor = card.isInMatchingSet ? CardContent.correctColor : ( card.isInNonMatchingSet ? CardContent.incorrectColor: .white)
                base.fill(cardColor)
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
            
            base.fill().opacity(card.isChosen ? 0.4 : 0)
            base.fill(.yellow).opacity(card.isHinted ? 0.4 : 0)
        }
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
                Capsule()
                    .foregroundStyle(color)
                    .opacity(getOpacity(shading))
                    .overlay(Capsule().stroke(color, lineWidth: strokeWidth))

            case .squiggle:
                Circle()
                    .foregroundStyle(color)
                    .opacity(getOpacity(shading))
                    .overlay(Circle().stroke(color, lineWidth: strokeWidth))

            }
            
        }
}

#Preview {
    CardView(SetGame<CardContent>.Card(id: "bro", content: CardContent(color: .blue, shape: .diamond, shading: .full, number: 3)))
}
