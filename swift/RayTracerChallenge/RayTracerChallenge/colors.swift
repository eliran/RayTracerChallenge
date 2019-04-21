//
// Created by Eliran Ben-Ezra on 2019-04-09.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import Foundation

struct Color {
    let r: Double
    let g: Double
    let b: Double
}

extension Double {
    func equals(_ other: Double, epsilon: Double = 0.01) -> Bool {
        return abs(self-other) <= epsilon
    }
}

extension Color: ColorByPosition {
  func at(_ point: Point) -> Color {
    return self
  }
}

func color(r: Double, g: Double, b: Double) -> Color {
    return Color(r: r, g: g, b: b)
}

extension Color: Equatable {
    public static func ==(lhs: Color, rhs: Color) -> Bool {
        return lhs.r.equals(rhs.r) && lhs.g.equals(rhs.g) && lhs.b.equals(rhs.b)
    }
}

extension Color {
    static func + (lhs: Color, rhs: Color) -> Color {
        return Color(r: lhs.r + rhs.r, g: lhs.g + rhs.g, b: lhs.b + rhs.b)
    }

    static func - (lhs: Color, rhs: Color) -> Color {
        return Color(r: lhs.r - rhs.r, g: lhs.g - rhs.g, b: lhs.b - rhs.b)
    }

    static func * (color: Color, scalar: Double) -> Color {
        return Color(r: color.r * scalar, g: color.g * scalar, b: color.b * scalar)
    }

    static func * (lhs: Color, rhs: Color) -> Color {
        return Color(r: lhs.r * rhs.r, g: lhs.g * rhs.g, b: lhs.b * rhs.b)
    }
}
