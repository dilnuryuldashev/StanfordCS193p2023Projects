//
//  Theme.swift
//  Memorize
//
//  Created by Dilnur Yuldashev on 1/31/25.
//

import Foundation

/***
 A Theme consists of a name for
 the Theme, a set of emoji to use, a number of pairs of cards to show (which is
 not necessarily the total number of emojis available in the theme), and an
 appropriate color to use to draw the cards.
 */

struct Theme<CardContent> {
    let name: String
    let emojis: [CardContent]
    let numberOfPairsToShow: Int
    let colorString: String
}
