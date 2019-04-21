//
//  patternsTests.swift
//  RayTracerTests
//
//  Created by Eliran Ben-Ezra on 4/21/19.
//  Copyright © 2019 Threeplay Inc. All rights reserved.
//

import XCTest

class PatternsTests: XCTestCase {
  let black = color(r: 0, g: 0, b: 0)
  let white = color(r: 1, g: 1, b: 1)

  func test_creating_a_stripe_pattern() {
    let pattern = Color.stripe(white, black)

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
}
