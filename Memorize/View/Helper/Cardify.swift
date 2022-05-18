//
//  Cardify.swift
//  Memorize
//
//  Created by Daniel Wippermann on 16.05.22.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isfacedUp: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if isfacedUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth:DrawingConstants.lineWidth)
            } else {
                shape.fill()
            }
            content.opacity(isfacedUp ? 1: 0)
        }
    }
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify(isFacedUp: Bool) -> some View {
        modifier(Cardify(isfacedUp: isFacedUp))
    }
}
