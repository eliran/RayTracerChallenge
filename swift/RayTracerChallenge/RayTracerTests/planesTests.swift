//
// Created by Eliran Ben-Ezra on 2019-04-19.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import XCTest

class PlanesTests: XCTestCase {
    func test_the_normal_of_a_plane_is_constant_everywhere() {
        let p = Shapes.plane()
        let n1 = p.localNormal(at: point(x: 0, y: 0, z: 0))
        let n2 = p.localNormal(at: point(x: 10, y: 0, z: -1))
        let n3 = p.localNormal(at: point(x: -5, y: 0, z: 150))

        expect(n1) == vector(x: 0, y: 1, z: 0)
        expect(n2) == vector(x: 0, y: 1, z: 0)
        expect(n3) == vector(x: 0, y: 1, z: 0)
    }

    func test_intersect_with_a_ray_parallel_to_the_plane() {
        let p = Shapes.plane()
        let r = ray(origin: point(x: 0, y: 10, z: 0), direction: vector(x: 0, y: 0, z: 1))
        let xs = p.intersects(ray: r)
        expect(xs.isEmpty) == true
    }

    func test_a_ray_intersecting_a_plane_from_above() {
        let p = Shapes.plane()
        let r = ray(origin: point(x: 0, y: -1, z: 0), direction: vector(x: 0, y: 1, z: 0))
        let xs = p.intersects(ray: r)

        expect(xs.count) == 1
        expect(xs[0].t) == 1
        expect(xs[0].object) == p
    }
}
