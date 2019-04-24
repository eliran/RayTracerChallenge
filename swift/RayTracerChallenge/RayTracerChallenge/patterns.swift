//
//  patterns.swift
//  RayTracerChallenge
//
//  Created by Eliran Ben-Ezra on 4/21/19.
//  Copyright © 2019 Threeplay Inc. All rights reserved.
//

import Foundation

protocol Pattern: DynamicEquatable {
  func color(at point: Point) -> Color
}

class MaterialPattern: ColorByPosition {
  private let pattern: Pattern
  let transform: Matrix

  init(pattern: Pattern, transform: Matrix = Matrix.identity4x4) {
    self.pattern = pattern
    self.transform = transform
  }

  func set(transform: Matrix) -> MaterialPattern {
    return MaterialPattern(pattern: self.pattern, transform: transform)
  }

  func at(_ point: Point, for object: Renderable?) -> Color {
    let objectPoint: Point
    if let objectInverse = object?.transform.inverse {
      objectPoint = objectInverse * point
    } else {
      objectPoint = point
    }
    let patternPoint = transform.inverse * objectPoint
    return pattern.color(at: patternPoint)
  }

  func isEqual(other: Any?) -> Bool {
    guard let other = other as? MaterialPattern else { return false }
    return self.transform == other.transform && self.pattern.isEqual(other: other.pattern)
  }
}

struct ColorPattern: Pattern {
  let a: Color
  let b: Color

  func color(at point: Point) -> Color {
    return Int(floor(point.x)) % 2 == 0 ? a : b
  }

  func isEqual(other: Any?) -> Bool {
    guard let other = other as? ColorPattern else { return false }
    return self.a == other.a && self.b == other.b
  }
}

extension Color {
  static func stripe(_ a: Color, _ b: Color) -> MaterialPattern {
    return MaterialPattern(pattern: ColorPattern(a: a, b: b))
  }
}

struct GradientPattern: Pattern {
  let a: Color
  let b: Color

  func color(at point: Point) -> Color {
    return a + (b - a)*(point.x - floor(point.x))
  }

  func isEqual(other: Any?) -> Bool {
    guard let other = other as? GradientPattern else { return false }
    return self.a == other.a && self.b == other.b
  }
}

extension Color {
  static func gradient(from a: Color, to b: Color) -> MaterialPattern {
    return MaterialPattern(pattern: GradientPattern(a: a, b: b))
  }
}
