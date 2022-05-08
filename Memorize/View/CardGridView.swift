//
//  CardGridView.swift
//  Memorize
//
//  Created by Daniel Wippermann on 01.05.22.
//

import SwiftUI

struct CardGridView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                ForEach(viewModel.cards) { card in
                    CardView(card: card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                }
            }
        }
        .foregroundColor(.red)
        .padding(.horizontal)
    }
}

struct CardGridView_Previews: PreviewProvider {
    static var previews: some View {
        CardGridView(viewModel: EmojiMemoryGame())
    }
}
