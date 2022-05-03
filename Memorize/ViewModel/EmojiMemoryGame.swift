//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Daniel Wippermann on 03.05.22.
//

///Because EmojiMemoryGame is part of the UI (NOT the View), we need to import SwiftUI.
import SwiftUI

class EmojiMemoryGame {
    private var model: MemoryGame<String>
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
}
