//
// Created by Eliran Ben-Ezra on 2019-04-13.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import XCTest

class SpheresTests: XCTestCase {
    func test_ray_intersects_a_sphere_at_two_points() {
        let r = ray(origin: point(x: 0, y: 0, z: -5), direction: vector(x: 0, y: 0, z: 1))
        let s = sphere()

        let xs = r.intersects(s)

        expect(xs.count) == 2
        expect(xs[0].t) == 4
        expect(xs[1].t) == 6
    }

    func test_ray_intersects_a_sphere_at_a_tangent() {
        let r = ray(origin: point(x: 0, y: 1, z: -5), direction: vector(x: 0, y: 0, z: 1))
        let s = sphere()

        let xs = r.intersects(s)

        expect(xs.count) == 2
        expect(xs[0].t) == 5
        expect(xs[1].t) == 5
    }

    func test_ray_misses_a_sphere() {
        let r = ray(origin: point(x: 0, y: 2, z: -5), direction: vector(x: 0, y: 0, z: 1))
        let s = sphere()

        let xs = r.intersects(s)

        expect(xs.count) == 0
    }

    func test_ray_originates_inside_a_sphere() {
        let r = ray(origin: point(x: 0, y: 0, z: 0), direction: vector(x: 0, y: 0, z: 1))
        let s = sphere()

        let xs = r.intersects(s)

        expect(xs.count) == 2
        expect(xs[0].t) == -1
        expect(xs[1].t) == 1
    }

    func test_a_sphere_is_behind_a_ray() {
        let r = ray(origin: point(x: 0, y: 0, z: 5), direction: vector(x: 0, y: 0, z: 1))
        let s = sphere()

        let xs = r.intersects(s)

        expect(xs.count) == 2
        expect(xs[0].t) == -6
        expect(xs[1].t) == -4
    }

    func test_intersects_set_the_object_on_the_intersection() {
        let r = ray(origin: point(x: 0, y: 0, z: -5), direction: vector(x: 0, y: 0, z: 1))
        let s = sphere()

        let xs = r.intersects(s)

        expect(xs.count) == 2
        expect(xs[0].object) == s
        expect(xs[1].object) == s
    }
}
