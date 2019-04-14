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

    func test_translating_a_ray() {
        let r = ray(origin: point(x: 1, y: 2, z: 3), direction: vector(x: 0, y: 1, z: 0))

        let r2 = r.transform(Matrix.translation(x: 3, y: 4, z: 5))

        expect(r2.origin) == point(x: 4, y: 6, z: 8)
        expect(r2.direction) == vector(x: 0, y: 1, z: 0)
    }

    func test_scaling_a_ray() {
        let r = ray(origin: point(x: 1, y: 2, z: 3), direction: vector(x: 0, y: 1, z: 0))

        let r2 = r.transform(Matrix.scaling(x: 2, y: 3, z: 4))

        expect(r2.origin) == point(x: 2, y: 6, z: 12)
        expect(r2.direction) == vector(x: 0, y: 3, z: 0)
    }
}
