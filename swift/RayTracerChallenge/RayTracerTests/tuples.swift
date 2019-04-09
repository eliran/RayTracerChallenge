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

    func test_adding_two_tuples() {
        let a1 = tuple(x: 3, y: -2, z: 5, w: 1)
        let a2 = tuple(x: -2, y: 3, z: 1, w: 0)

        expect(a1 + a2) == tuple(x: 1, y: 1, z: 6, w: 1)
    }

    func test_subtracting_two_tuples() {
        let p1 = point(x: 3, y: 2, z: 1)
        let p2 = point(x: 5, y: 6, z: 7)

        expect(p1 - p2) == vector(x: -2, y: -4, z: -6)
    }

    func test_subtracting_a_vector_from_a_point() {
        let p = point(x: 3, y: 2, z: 1)
        let v = vector(x: 5, y: 6, z: 7)

        expect(p - v) == point(x: -2, y: -4, z: -6)
    }

    func test_subtracting_two_vectors() {
        let v1 = vector(x: 3, y: 2, z: 1)
        let v2 = vector(x: 5, y: 6, z: 7)

        expect(v1 - v2) == vector(x: -2, y: -4, z: -6)
    }

    func test_subtracting_a_vector_from_zero_vector() {
        let zero = vector(x: 0, y: 0, z: 0)
        let v = vector(x: 1, y: -2, z: 3)

        expect(zero - v) == vector(x: -1, y: 2, z: -3)
    }

    func test_negating_a_tuple() {
        let a = tuple(x: 1, y: -2, z: 3, w: -4)

        expect(-a) == tuple(x: -1, y: 2, z: -3, w: 4)
    }

    func test_multiplying_tuple_by_scalar() {
        let a = tuple(x: 1, y: -2, z: 3, w: -4)

        expect(a * 3.5) == tuple(x: 3.5, y: -7, z: 10.5, w: -14)
    }

    func test_multiplying_tuple_by_a_fraction() {
        let a = tuple(x: 1, y: -2, z: 3, w: -4)

        expect(a * 0.5) == tuple(x: 0.5, y: -1, z: 1.5, w: -2)
    }

    func test_computing_magnitude_of_vector_1_0_0() {
        let v = vector(x: 1, y: 0, z: 0)

        expect(v.magnitude) == 1
    }

    func test_computing_magnitude_of_vector_0_1_0() {
        let v = vector(x: 0, y: 1, z: 0)

        expect(v.magnitude) == 1
    }

    func test_computing_magnitude_of_vector_0_0_1() {
        let v = vector(x: 0, y: 0, z: 1)

        expect(v.magnitude) == 1
    }

    func test_computing_magnitude_of_vector_1_2_3() {
        let v = vector(x: 1, y: 2, z: 3)

        expect(v.magnitude) == sqrt(14)
    }

    func test_computing_magnitude_of_vector_n1_n2_n3() {
        let v = vector(x: -1, y: -2, z: -3)

        expect(v.magnitude) == sqrt(14)
    }
}
