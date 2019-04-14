//
// Created by Eliran Ben-Ezra on 2019-04-13.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import XCTest

class RaysTests: XCTestCase {
    func test_creating_and_querying_a_ray() {
        let o = point(x: 1, y: 2, z: 3)
        let d = vector(x: 4, y: 5, z: 6)

        let r = ray(origin: o, direction: d)

        expect(r.origin) == o
        expect(r.direction) == d
    }

    func test_computing_a_point_from_a_distance() {
        let r = ray(origin: point(x: 2, y: 3, z: 4), direction: vector(x: 1, y: 0, z: 0))

        expect(r.position(0)) == point(x: 2, y: 3, z: 4)
        expect(r.position(1)) == point(x: 3, y: 3, z: 4)
        expect(r.position(-1)) == point(x: 1, y: 3, z: 4)
        expect(r.position(2.5)) == point(x: 4.5, y: 3, z: 4)
    }
}
