//
//  CardGridView.swift
//  Memorize
//
//  Created by Daniel Wippermann on 01.05.22.
//

import SwiftUI

struct CardGridView: View {
    let emojis = ["🚀","✈️","🚄","🚜","🚁","🚚","🛸","🚡","⚓️"]
    @State private var emojiCounter = 2
    var body: some View {
        VStack { 
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(emojis[0..<emojiCounter], id: \.self) { emoji in
                        CardView(content: emoji)
                            .aspectRatio(2/3, contentMode: .fit)
                    }
                }
                .foregroundColor(.red)
            }
        }
        .padding(.horizontal)
    }
}

struct CardGridView_Previews: PreviewProvider {
    static var previews: some View {
        CardGridView()
    }
}
