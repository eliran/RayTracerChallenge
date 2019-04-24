//
//  patternsTests.swift
//  RayTracerTests
//
//  Created by Eliran Ben-Ezra on 4/21/19.
//  Copyright © 2019 Threeplay Inc. All rights reserved.
//

import XCTest

extension Color {
  private struct TestPattern: Pattern, Equatable {
    func color(at point: Point) -> Color {
      return Color(r: point.x, g: point.y, b: point.z)
    }

    func isEqual(other: Any?) -> Bool {
      return self == (other as? TestPattern)
    }
  }

  static func testPattern() -> MaterialPattern {
    return MaterialPattern(pattern: TestPattern())
  }
}

class PatternsTests: XCTestCase {
  let black = color(r: 0, g: 0, b: 0)
  let white = color(r: 1, g: 1, b: 1)

  func test_the_default_pattern_transformation() {
    let pattern = Color.testPattern()

    expect(pattern.transform) == Matrix.identity4x4
  }

  func test_assigning_a_transformation() {
    let pattern = Color.testPattern().set(transform: .translation(x: 1, y: 2, z: 3))

    expect(pattern.transform) == Matrix.translation(x: 1, y: 2, z: 3)
  }

  func test_a_pattern_with_an_object_transformation() {
    let s = Shapes.sphere().set(transform: .scaling(x: 2, y: 2, z: 2))
    let p = Color.testPattern()

    expect(p.at(point(x: 2, y: 3, z: 4), for: s)) == color(r: 1, g: 1.5, b: 2)
  }

  func test_a_pattern_with_a_pattern_transformation() {
    let s = Shapes.sphere()
    let p = Color.testPattern().set(transform: .scaling(x: 2, y: 2, z: 2))

    expect(p.at(point(x: 2, y: 3, z: 4), for: s)) == color(r: 1, g: 1.5, b: 2)
  }

  func test_a_pattern_with_both_object_and_pattern_transformation() {
    let s = Shapes.sphere().set(transform: .scaling(x: 2, y: 2, z: 2))
    let p = Color.testPattern().set(transform: .translation(x: 0.5, y: 1, z: 1.5))

    expect(p.at(point(x: 2.5, y: 3, z: 3.5), for: s)) == color(r: 0.75, g: 0.5, b: 0.25)
  }

  func test_creating_a_stripe_pattern() {
    let pattern = ColorPattern(a: white, b: black)

    expect(pattern.a) == white
    expect(pattern.b) == black
  }

  func test_a_stripe_pattern_is_constant_in_y() {
    let pattern = Color.stripe(white, black)

    expect(pattern.at(point(x: 0, y: 0, z: 0))) == white
    expect(pattern.at(point(x: 0, y: 1, z: 0))) == white
    expect(pattern.at(point(x: 0, y: 2, z: 0))) == white
  }

  func test_a_stripe_pattern_is_constant_in_z() {
    let pattern = Color.stripe(white, black)

    expect(pattern.at(point(x: 0, y: 0, z: 0))) == white
    expect(pattern.at(point(x: 0, y: 0, z: 1))) == white
    expect(pattern.at(point(x: 0, y: 0, z: 2))) == white
  }

  func test_a_stripe_pattern_alternates_x() {
    let pattern = Color.stripe(white, black)

    expect(pattern.at(point(x: 0, y: 0, z: 0))) == white
    expect(pattern.at(point(x: 0.9, y: 0, z: 0))) == white
    expect(pattern.at(point(x: 1, y: 0, z: 0))) == black
    expect(pattern.at(point(x: -0.1, y: 0, z: 0))) == black
    expect(pattern.at(point(x: -1, y: 0, z: 0))) == black
    expect(pattern.at(point(x: -1.1, y: 0, z: 0))) == white
  }

  func test_stripes_with_an_object_transformation() {
    let p = Color.stripe(white, black)
    let o = Shapes.sphere().set(transform: .scaling(x: 2, y: 2, z: 2))

    expect(p.at(point(x: 1.5, y: 0, z: 0), for: o)) == white
  }

  func test_stripes_with_a_pattern_transformation() {
    let p = Color.stripe(white, black).set(transform: .scaling(x: 2, y: 2, z: 2))

    expect(p.at(point(x: 1.5, y: 0, z: 0), for: nil)) == white
  }

  func test_stripes_with_both_an_object_and_pattern_transformation() {
    let p = Color.stripe(white, black).set(transform: .translation(x: 0.5, y: 0, z: 0))
    let o = Shapes.sphere().set(transform: .scaling(x: 2, y: 2, z: 2))

    expect(p.at(point(x: 2.5, y: 0, z: 0), for: o)) == white
  }

  func test_a_gradient_linearly_interpolates_between_colors() {
    let p = Color.gradient(from: white, to: black)

    expect(p.at(point(x: 0, y: 0, z: 0), for: nil)) == white
    expect(p.at(point(x: 0.25, y: 0, z: 0), for: nil)) == color(r: 0.75, g: 0.75, b: 0.75)
    expect(p.at(point(x: 0.5, y: 0, z: 0), for: nil)) == color(r: 0.5, g: 0.5, b: 0.5)
    expect(p.at(point(x: 0.75, y: 0, z: 0), for: nil)) == color(r: 0.25, g: 0.25, b: 0.25)
  }
}
