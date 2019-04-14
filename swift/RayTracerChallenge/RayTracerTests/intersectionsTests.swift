//
// Created by Eliran Ben-Ezra on 2019-04-13.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import XCTest

class IntersectionsTest: XCTestCase {
    func test_an_intersection_encapsulates_t_and_object() {
        let s = sphere()
        let i = intersection(t: 3.5, object: s)

        expect(i.t) == 3.5
        expect(i.object) == s
    }

    func test_aggregating_intersections() {
        let s = sphere()
        let i1 = intersection(t: 1, object: s)
        let i2 = intersection(t: 2, object: s)

        let xs = intersections(i1, i2)

        expect(xs.count) == 2
        expect(xs[0].t) == 1
        expect(xs[1].t) == 2
    }

    func test_the_hit_when_all_intersections_have_positive_t() {
        let s = sphere()
        let i1 = intersection(t: 1, object: s)
        let i2 = intersection(t: 2, object: s)

        expect(hit(intersections(i1, i2))) == i1
    }

    func test_the_hit_when_some_intersections_have_negative_t() {
        let s = sphere()
        let i1 = intersection(t: -1, object: s)
        let i2 = intersection(t: 1, object: s)

        expect(hit(intersections(i1, i2))) == i2
    }

    func test_the_hit_when_all_intersections_have_negagive_t() {
        let s = sphere()
        let i1 = intersection(t: -2, object: s)
        let i2 = intersection(t: -1, object: s)

        expect(hit(intersections(i1, i2))) == nil
    }

    func test_the_hit_is_always_the_lowest_nonnegative_intersection() {
        let s = sphere()
        let i1 = intersection(t: 5, object: s)
        let i2 = intersection(t: 7, object: s)
        let i3 = intersection(t: -3, object: s)
        let i4 = intersection(t: 2, object: s)

        expect(hit(intersections(i1, i2, i3, i4))) == i4
    }
}
