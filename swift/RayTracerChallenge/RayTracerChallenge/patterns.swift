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
  let transform: Matrix
}

extension ColorPattern: ColorByPosition {
  func at(_ point: Point, for object: Renderable?) -> Color {
    let objectPoint: Point
    if let objectInverse = object?.transform.inverse {
      objectPoint = objectInverse * point
    } else {
      objectPoint = point
    }
    let patternPoint = transform.inverse * objectPoint
    return Int(floor(patternPoint.x)) % 2 == 0 ? a : b
  }

  func isEqual(other: Any?) -> Bool {
    guard let other = other as? ColorPattern else { return false }
    return self.a == other.a && self.b == other.b
  }
}

extension ColorPattern {
  func set(transform: Matrix) -> ColorPattern {
    return ColorPattern(a: self.a, b: self.b, transform: transform)
  }
}

extension Color {
  static func stripe(_ a: Color, _ b: Color) -> ColorPattern {
    return ColorPattern(a: a, b: b, transform: Matrix.identity4x4)
  }
}
