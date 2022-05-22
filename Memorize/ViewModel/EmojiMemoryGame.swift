//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Daniel Wippermann on 03.05.22.
//

///Because EmojiMemoryGame is part of the UI (NOT the View), we need to import SwiftUI.
import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private static let emojis = ["🚀","✈️","🚄","🚜","🚁","🚚","🛸","🚡","⚓️"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame(numberOfPairsOfCards: 8) { pairIndex in
            emojis[pairIndex]
        }
    }
    @Published private var model = createMemoryGame()
    
    var cards: Array<Card> {
        model.cards
    }
    ///Example for previewing content in CardView.swift
    static let exampleCard = MemoryGame.Card(isFacedUp: true, isMatched: false, content: "🤪")
    
    //MARK: - Intent(s)
    func choose(_ card: Card) {
        model.choose(card)
    }
    func shuffle() {
        model.shuffe()
    }
    func restart() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
