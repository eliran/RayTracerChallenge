//
// Created by Eliran Ben-Ezra on 2019-04-14.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import XCTest

class LightsTests: XCTestCase {
    func test_a_point_light_has_a_position_and_intensity() {
        let i = color(r: 1, g: 1, b: 1)
        let p = point(x: 0, y: 0, z: 0)

        let l = Light.point(position: p, intensity: i)

        expect(l.position) == p
        expect(l.intensity) == i
    }
}
