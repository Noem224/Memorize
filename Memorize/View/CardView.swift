//
//  CardView.swift
//  Memorize
//
//  Created by Daniel Wippermann on 28.04.22.
//

import SwiftUI

struct CardView: View {
    
    let card: EmojiMemoryGame.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                /// Group is a "bag of Lego" container
                /// it's useful for propagating view modifiers to multiple views
                /// (as we are doing below, for example, with opacity)
                Group {
                    /// card.isConsumingBonusTime is changed by the Model quite often
                    /// it changes any time a card's isFaceUp changes (or isMatched)
                    /// so the two Pies here are swapping back and forth as isFaceUp changes
                    /// any time we are not consuming bonus time, the lower Pie appears
                    /// (it is not animated and is just showing how much time is left)
                    /// any time we ARE consuming bonus time, the upper Pie appears
                    /// and when it appears (onAppear), it starts animating its own endAngle
                    /// by first setting its animatedBonusRemaining to however much time is remaining
                    /// then animating setting that to zero inside an explicit animation
                    /// (and since this represents a change to animatedBonusRemaining, it will animate that change)
                    /// if isConsumingBonusTime changes in the middle of the animation
                    /// the top Pie below will simply be removed from the UI and the animation abandoned
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0 - 90), endAngle: Angle(degrees: (1 - animatedBonusRemaining) * 360 - 90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0 - 90), endAngle: Angle(degrees: (1 - card.bonusRemaining) * 360 - 90))
                    }
                }
                .padding(5)
                .opacity(0.5)
                Text(card.content)
                    .rotationEffect(.degrees(card.isMatched ? 360: 0))
                /// only view modifiers ABOVE this .animation call are animated by it
                    .animation(.linear(duration: 1.0), value: card.isMatched)
                    .font(.system(size: DrawingConstants.fontSize))
                /// view modifications like this .scaleEffect are not affected by the call to .animation ABOVE it
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            /// this is the same as .modifier(Cardify(isFaceUp: card.isFaceUp))
            /// it turns our ZStack with a Pie and a Text in it into a "card" on screen
            /// it does this by just returning its own ZStack with RoundedRectangles and such in it
            /// see Cardify.swift
            .cardify(isFacedUp: card.isFacedUp)
        }
    }
    /// the "scale factor" to scale our Text up so that it fits the geometry.size offered to us
    private func scale(thatFits size: CGSize) -> CGFloat {
        return min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    private func font(in size: CGSize) -> Font {
        Font.system(size: .minimum(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: EmojiMemoryGame.exampleCard)
    }
}
