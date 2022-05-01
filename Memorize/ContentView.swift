//
//  ContentView.swift
//  Memorize
//
//  Created by Daniel Wippermann on 28.04.22.
//

import SwiftUI

struct ContentView: View {
    let emojis = ["🚀","✈️","🚄","🚜","🚁","🚚","🛸","🚡","⚓️"]
    @State private var emojiCounter = 2
    var body: some View {
        VStack {
            HStack {
                ForEach(emojis[0..<emojiCounter], id: \.self) { emoji in
                    CardView(content: emoji)
                }
            }
            .padding(.horizontal)
            .foregroundColor(.red)
            HStack {
                remove
                Button(action: {}, label: {Text("Shuffle")})
                add
            }
            .font(.largeTitle)
            .padding(.horizontal)
        }
    }
    var remove: some View {
        Button(action: {
            withAnimation(.spring()) {
                emojiCounter -= 1
            }
        }, label: {
            Image(systemName: "minus.circle")
            
        })
        .disabled(emojiCounter == 0 ? true: false)
    }
    var add: some View {
        Button(action: {
            withAnimation(.spring()) {
                emojiCounter += 1
            }
        }, label: {
            Image(systemName: "plus.circle")
            
        })
        .disabled(emojiCounter == emojis.count ? true: false)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
