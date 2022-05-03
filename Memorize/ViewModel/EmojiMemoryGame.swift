//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Daniel Wippermann on 03.05.22.
//

///Because EmojiMemoryGame is part of the UI (NOT the View), we need to import SwiftUI.
import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    static let emojis = ["🚀","✈️","🚄","🚜","🚁","🚚","🛸","🚡","⚓️"]
    
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame(numberOfPairsOfCards: 4) { pairIndex in
            emojis[pairIndex]
        }
    }
    private var model: MemoryGame<String> = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    ///Example for previewing content
    static let exampleCard = MemoryGame.Card(isFacedUp: true, isMatched: false, content: "🤪")
}
