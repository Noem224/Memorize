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
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        self.cards = Array<Card>()
        ///Add numberOfPairsOfCards x 2 to cards array
        for pairIndex in 0...numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
    }
    
    struct Card {
        ///First time, the player is starting the game, the cards aren't faced up and the player doesn't has any matches yet.
        var isFacedUp: Bool = false
        var isMatched: Bool = false
        
        ///Use generic, because we want an UI independent Model and in the future, the content may change from Emojis for example to Images etc.
        var content: CardContent
    }
}

