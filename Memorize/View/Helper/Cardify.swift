//
//  Cardify.swift
//  Memorize
//
//  Created by Daniel Wippermann on 16.05.22.
//

import SwiftUI

struct Cardify: ViewModifier, Animatable {

    init(isfacedUp: Bool) {
        self.rotation = isfacedUp ? 0 : 180
    }
    
    var rotation: Double
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth:DrawingConstants.lineWidth)
            } else {
                shape.fill()
            }
            content.opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (x: 0, y: 1, z: 0))
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
