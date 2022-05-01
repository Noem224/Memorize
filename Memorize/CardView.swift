//
//  CardView.swift
//  Memorize
//
//  Created by Daniel Wippermann on 28.04.22.
//

import SwiftUI

struct CardView: View {
    let content: String
    let shape = RoundedRectangle(cornerRadius: 20)
    @State private var isFaceUp = false
    var body: some View {
        ZStack {
            if isFaceUp {
                shape
                    .fill()
                    .foregroundColor(.white)
                shape
                    .stroke(lineWidth: 3)
                Text(content)
                    .font(.largeTitle)
            } else {
                shape
                    .fill()
            }
        }
        .onTapGesture { isFaceUp.toggle() }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(content: "🚀")
    }
}
