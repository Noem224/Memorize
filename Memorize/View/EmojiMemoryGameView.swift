//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Daniel Wippermann on 01.05.22.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    /// our ViewModel
    @ObservedObject var game: EmojiMemoryGame
    
    /// a token which provides a namespace for the id's used in matchGeometryEffect
    @Namespace private var dealingNamespace
    
    /// our body
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                HStack {
                    restart
                    Spacer()
                    shuffle
                }
                .padding(.horizontal)
            }
            deckBody
        }
        .padding()
    }
    
    /// private state used to temporary track
    /// whether a card has been dealt or not
    /// contains id's of MemoryGame<String>.Cards
    @State private var dealt = Set<UUID>()
    
    /// marks the given card as having been dealt
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    /// returns whether the given card has not been dealt yet
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    /// an Animation used to deal the cards out "not all at the same time"
    /// the Animation is delayed depending on the index of the given card
    /// in our ViewModel's (and thus our Model's) cards array
    /// the further the card is into that array, the more the animation is delayed
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeIn(duration: CardConstants.dealDuration).delay(delay)
    }
    
    /// returns a Double which is a bigger number the closer a card is to the front of the cards array
    /// used by both of our matchedGeometryEffect CardViews
    /// so that they order the cards in the "z" direction in the same way
    /// (the "z" direction is the direction going up out of the device towards the user)
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id}) ?? 0)
    }
    
    /// the body of the game itself
    /// (i.e. not include any of the control buttons or the deck)
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if isUndealt(card) || card.isMatched && !card.isFacedUp {
                Color.clear
            } else {
                CardView(card: card)
                /// see other CardView below that has same matchedGeometryEffect
                /// if that one arrives/departs the UI
                /// at the same time that we are departing/arriving
                /// then the arriving one will fly across the screen (and resize)
                /// from where the departing one left
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                /// removal: .scale makes matched cards shrink out of existence
                    .transition(.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        /// animate the user Intent function that chooses a card
                        /// (using the default animation)
                        withAnimation {
                            game.choose(card)
                        }
                    }
            }
        }
        .foregroundColor(CardConstants.color)
    }
    
    /// the body of the deck from which we deal the cards out
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                /// see other matchedGeometryEffect above
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                /// removal: .identity here because removal of this CardView
                /// is actually going to be animated by the matchedGeometryEffect
                /// so we don't want it to ALSO fade or scale out
                /// (since transitions and matchedGeometryEffects are not mutually exclusive)
                    .transition(.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        /// generally using magic numbers as arguments to frame(width:height:)
        /// should be avoided
        /// much better to let Views naturally lay themselves out if possible
        /// but here, it's not clear what the "natural size" of a deck would be
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            /// "deal" cards
            /// note that this is not calling a user Intent function
            /// (instead it is just setting some of our private @State)
            /// that's because "dealing" is purely a temporary UI/animation thing
            /// it has nothing to do with our Model
            /// because "dealing" is not part of the Memorize game logic
            /// (dealing IS part of some card games, for example, Set)
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    var shuffle: some View {
        Button("Shuffle") {
            /// animated user Intent function call
            // TODO: YOU MUST ADD THIS INTENT FUNC TO YOUR VIEWMODEL
            withAnimation {
                game.shuffle()
            }
        }
    }
    var restart: some View {
        Button("Restart") {
            /// animated user Intent function call
            /// and, at the same time, resetting our local "dealing" private State
            // TODO: YOU MUST ADD THIS INTENT FUNC TO YOUR VIEWMODEL
            withAnimation {
                dealt = []
                game.restart()
            }
        }
    }
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    /// flip over the first card just so our Preview is always showing one face up card
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
    }
}
