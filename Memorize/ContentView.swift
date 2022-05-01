//
//  ContentView.swift
//  Memorize
//
//  Created by Daniel Wippermann on 28.04.22.
//

import SwiftUI

struct ContentView: View {
    let emojis = ["🚀","✈️"]
    var body: some View {
        HStack {
            ForEach(emojis, id: \.self) { emoji in
                CardView(content: emoji)
            }
        }
        .padding(.horizontal)
        .foregroundColor(.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
