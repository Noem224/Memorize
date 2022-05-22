//
//  Pie.swift
//  Memorize
//
//  Created by Daniel Wippermann on 14.05.22.
//

import SwiftUI

struct Pie: Shape {
    
    var startAngle: Angle
    var endAngle: Angle
    var clockWise = false
    
    /// the Shape protocol inherits from Animatable
    /// and this var is the only thing in Animatable
    /// so by implementing it to get/set our pair of angles
    /// we are thus animatable
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(startAngle.radians, endAngle.radians)
        }
        set {
            startAngle = Angle(radians: newValue.first)
            endAngle = Angle(radians: newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * cos(startAngle.radians),
            y: center.y + radius * sin(startAngle.radians)
        )
        /// we did this by creating a path and returning it
        /// but there is also a Path { } version we could have used
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: !clockWise
        )
        p.addLine(to: center)
        return p
    }
}
