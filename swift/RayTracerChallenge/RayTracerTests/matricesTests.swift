//
// Created by Eliran Ben-Ezra on 2019-04-10.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import XCTest

class MatricesTest: XCTestCase {
    func test_constructing_and_inspecting_4x4_matrix() {
        let m = matrix4x4(
            (
                (1, 2, 3, 4),
                (5.5, 6.5, 7.5, 8.5),
                (9, 10, 11, 12),
                (13.5, 14.5, 15.5, 16.5)
            )
        )

        expect(m[0, 0]) == 1
        expect(m[0, 3]) == 4
        expect(m[1, 0]) == 5.5
        expect(m[1, 2]) == 7.5
        expect(m[2, 2]) == 11
        expect(m[3, 0]) == 13.5
        expect(m[3, 2]) == 15.5
    }

    func test_constructing_and_inspecting_2x2_matrix() {
        let m = matrix2x2(
            (
                (-3, 5),
                (1, -2)
            )
        )

        expect(m[0, 0]) == -3
        expect(m[0, 1]) == 5
        expect(m[1, 0]) == 1
        expect(m[1, 1]) == -2
    }

    func test_constructing_and_inspecting_3x3_matrix() {
        let m = matrix3x3(
            (
                (-3, 5, 0),
                (1, -2, -7),
                (0, 1, 1)
            )
        )

        expect(m[0, 0]) == -3
        expect(m[1, 1]) == -2
        expect(m[2, 2]) == 1
    }

    func test_equality_with_identical_matrices() {
        let m1 = matrix4x4(((1,2,3,4), (5,6,7,8), (9,8,7,6), (5,4,3,2)))
        let m2 = matrix4x4(((1,2,3,4), (5,6,7,8), (9,8,7,6), (5,4,3,2)))

        expect(m1) == m2
    }

    func test_equality_with_different_matrices() {
        let m1 = matrix4x4(((1,2,3,4), (5,6,7,8), (9,8,7,6), (5,4,3,2)))
        let m2 = matrix4x4(((2,3,4,5), (6,7,8,9), (8,7,6,5), (4,3,2,1)))

        expect(m1) != m2
    }

    func test_multiply_two_4x4_matrices() {
        let m1 = matrix4x4(((1,2,3,4), (5,6,7,8), (9,8,7,6), (5,4,3,2)))
        let m2 = matrix4x4(((-2,1,2,3), (3,2,1,-1), (4,3,6,5), (1,2,7,8)))

        expect(m1 * m2) == matrix4x4(((20,22,50,48), (44,54,114,108), (40,58,110,102), (16,26,46,42)))
    }

    func test_matrix_multiplied_by_a_tuple() {
        let m1 = matrix4x4(((1,2,3,4), (2,4,4,2), (8,6,4,1), (0,0,0,1)))
        let t = tuple(x: 1, y: 2, z: 3, w: 1)

        expect(m1 * t) == tuple(x: 18, y: 24, z: 33, w: 1)
    }

    func test_matrix_multiplied_by_identify_matrix() {
        let m1 = matrix4x4(((0,1,2,4), (1,2,4,8), (2,4,8,16), (4,8,16,32)))
        let i = Matrix.identity4x4

        expect(i * m1) == m1
    }

    func test_transposing_a_matrix() {
        let m = matrix4x4(((0,9,3,0), (9,8,0,8), (1,8,5,3), (0,0,5,8)))

        expect(m.transposed) == matrix4x4(((0,9,1,0), (9,8,8,0), (3,0,5,5), (0,8,3,8)))
    }

    func test_transposing_the_identity_matrix() {
        let m = Matrix.identity4x4

        expect(m.transposed) == m
    }
}
