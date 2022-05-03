//
//  CardView.swift
//  Memorize
//
//  Created by Daniel Wippermann on 28.04.22.
//

import SwiftUI

struct CardView: View {
    let card: MemoryGame<String>.Card
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 20)
        ZStack {
            if card.isFacedUp {
                shape
                    .fill()
                    .foregroundColor(.white)
                shape
                    .strokeBorder(lineWidth: 3)
                Text(card.content)
                    .font(.largeTitle)
            } else {
                shape
                    .fill()
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: EmojiMemoryGame.exampleCard)
    }
}
