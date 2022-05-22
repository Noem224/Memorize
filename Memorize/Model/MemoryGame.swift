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
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFacedUp,
           !cards[chosenIndex].isMatched
        {
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
    }
    
    mutating func shuffe() {
        cards.shuffle()
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        self.cards = []
        ///Add numberOfPairsOfCards x 2 to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        let id = UUID()
        ///First time, the player is starting the game, the cards aren't faced up and the player doesn't has any matches yet.
        var isFacedUp = false {
            didSet {
                if isFacedUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        ///Use generic, because we want an UI independent Model and in the future, the content may change from Emojis for example to Images etc.
        let content: CardContent
        
        // MARK: - Bonus Time
        
        /// this could give matching bonus points
        /// if the user matches the card
        /// before a certain amount of time passes during which the card is face up
        
        /// can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        /// how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        /// the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        /// the accumulated time this card has been face up in the past
        /// (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        /// how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        /// percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        /// whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        /// whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFacedUp && !isMatched && bonusTimeRemaining > 0
        }
        
        /// called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        /// called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
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
