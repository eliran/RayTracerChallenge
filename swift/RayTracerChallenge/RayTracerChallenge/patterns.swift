//
//  patterns.swift
//  RayTracerChallenge
//
//  Created by Eliran Ben-Ezra on 4/21/19.
//  Copyright © 2019 Threeplay Inc. All rights reserved.
//

import Foundation

struct ColorPattern {
  let a: Color
  let b: Color
}

extension ColorPattern: ColorByPosition {
  func at(_ point: Point) -> Color {
    return Int(floor(point.x)) % 2 == 0 ? a : b
  }
}

extension Color {
  static func stripe(_ a: Color, _ b: Color) -> ColorPattern {
    return ColorPattern(a: a, b: b)
  }
}
