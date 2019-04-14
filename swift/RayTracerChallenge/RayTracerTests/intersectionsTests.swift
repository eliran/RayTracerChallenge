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
}

