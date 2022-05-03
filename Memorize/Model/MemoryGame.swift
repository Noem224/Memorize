//
//  MemoryGame.swift
//  Memorize
//
//  Created by Daniel Wippermann on 02.05.22.
//

import Foundation

struct MemoryGame<CardContent> {
    private(set) var cards: Array<Card>
    
    func choose(_ card: Card) {
        
    }
    
    struct Card {
        var isFacedUp: Bool
        var isMatched: Bool
        
        ///Use generic, because we want an UI independent Model and in the future, the content may change from Emojis for example to Images etc.
        var content: CardContent
    }
}

