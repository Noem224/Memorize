//
//  MemoryGame.swift
//  Memorize
//
//  Created by Daniel Wippermann on 02.05.22.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        ///To get the indexOfTheOneAndOnlyFaceUpCard, we filter through cards.indices to look for the cards, that are faced up and finaly return the oneAndOnly
        get { cards.indices.filter({ cards[$0].isFacedUp }).oneAndOnly }
        ///We forEach through the cards indices and set the faceUp property where index equals the newValue
        set { cards.indices.forEach { cards[$0].isFacedUp = ($0 == newValue) } }
    }
    
    mutating func choose(_ card: Card) {
        guard let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
              !cards[chosenIndex].isFacedUp,
              !cards[chosenIndex].isMatched
                
        else {return}
        
        if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
            if cards[potentialMatchIndex].content == cards[chosenIndex].content {
                cards[chosenIndex].isMatched = true
                cards[potentialMatchIndex].isMatched = true
            }
            cards[chosenIndex].isFacedUp.toggle()
        } else {
            indexOfTheOneAndOnlyFaceUpCard = chosenIndex
        }
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        self.cards = []
        ///Add numberOfPairsOfCards x 2 to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
    }
    
    struct Card: Identifiable {
        let id = UUID()
        ///First time, the player is starting the game, the cards aren't faced up and the player doesn't has any matches yet.
        var isFacedUp = false
        var isMatched = false
        
        ///Use generic, because we want an UI independent Model and in the future, the content may change from Emojis for example to Images etc.
        let content: CardContent
    }
}

extension Array {
    var oneAndOnly: Element? {
        if self.count == 1 {
            return self.first
        } else {
            return nil
        }
    }
}
