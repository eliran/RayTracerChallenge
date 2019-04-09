//  Created by Eliran Ben-Ezra on 4/8/19.
//  Copyright © 2019 Threeplay Inc. All rights reserved.
//

import XCTest

class TuplesTest: XCTestCase {

    func test_that_a_tuple_with_w_equal_1_0_is_a_point() {
        let a = tuple(x: 4.3, y: -4.2, z: 3.1, w: 1.0)

        expect(a.x) == 4.3
        expect(a.y) == -4.2
        expect(a.z) == 3.1
        expect(a.w) == 1.0
        expect(a.isPoint) == true
        expect(a.isVector) == false
    }

    func test_that_a_tuple_with_w_equal_0_is_a_vector() {
        let a = tuple(x: 4.3, y: -4.2, z: 3.1, w: 0.0)

        expect(a.x) == 4.3
        expect(a.y) == -4.2
        expect(a.z) == 3.1
        expect(a.w) == 0.0
        expect(a.isPoint) == false
        expect(a.isVector) == true
    }

    func test_that_point_creates_tuples_with_w_equals_1() {
        let a = point(x: 4, y: -4, z: 3)

        expect(a) == tuple(x: 4, y: -4, z: 3, w: 1)
    }

    func test_that_vector_creates_tuples_with_w_equals_0() {
        let a = vector(x: 4, y: -4, z: 3)

        expect(a) == tuple(x: 4, y: -4, z: 3, w: 0)
    }
}
