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

    func test_calculating_the_determinant_of_2x2_matrix() {
        let m = matrix2x2(((1,5), (-3,2)))

        expect(m.determinant) == 17
    }

    func test_submatrix_of_3x3_matrix_is_2x2_matrix() {
        let m = matrix3x3(((1,5,0), (-3,2,7), (0,6,-3)))

        expect(m.submatrix(0, 2)) == matrix2x2(((-3,2), (0,6)))
    }

    func test_submatrix_of_4x4_matrix_is_3x3_matrix() {
        let m = matrix4x4(((-6,1,1,6), (-8,5,8,6), (-1,0,8,2), (-7,1,-1,1)))

        expect(m.submatrix(2, 1)) == matrix3x3(((-6,1,6), (-8,8,6), (-7,-1,1)))
    }

    func test_minor_of_a_3x3_matrix() {
        let m = matrix3x3(((3,5,0), (2,-1,-7), (6,-1,5)))
        let b = m.submatrix(1, 0)

        expect(b.determinant) == 25
        expect(m.minor(1, 0)) == 25
    }

    func test_cofactor_of_a_3x3_matrix() {
        let m = matrix3x3(((3,5,0), (2,-1,-7), (6,-1,5)))

        expect(m.minor(0, 0)) == -12
        expect(m.cofactor(0, 0)) == -12
        expect(m.minor(1, 0)) == 25
        expect(m.cofactor(1, 0)) == -25
    }

    func test_calculating_the_determinant_of_a_3x3_matrix() {
        let m = matrix3x3(((1,2,6), (-5,8,-4), (2,6,4)))

        expect(m.cofactor(0, 0)) == 56
        expect(m.cofactor(0, 1)) == 12
        expect(m.cofactor(0, 2)) == -46
        expect(m.determinant) == -196
    }

    func test_calculating_the_determinant_of_a_4x4_matrix() {
        let m = matrix4x4(((-2,-8,3,5), (-3,1,7,3), (1,2,-9,6), (-6,7,7,-9)))

        expect(m.cofactor(0, 0)) == 690
        expect(m.cofactor(0, 1)) == 447
        expect(m.cofactor(0, 2)) == 210
        expect(m.cofactor(0, 3)) == 51
        expect(m.determinant) == -4071
    }

    func test_testing_invertible_matrix_for_invertibility() {
        let m = matrix4x4(((6,4,4,4), (5,5,7,6), (4,-9,3,-7), (9,1,7,-6)))

        expect(m.determinant) == -2120
        expect(m.isInvertible) == true
    }

    func test_testing_noninvertible_matrix_for_invertibility() {
        let m = matrix4x4(((-4,2,-2,-3), (9,6,2,6), (0,-5,1,-5), (0,0,0,0)))

        expect(m.determinant) == 0
        expect(m.isInvertible) == false
    }

    func test_calculating_the_inverse_of_a_matrix() {
        let m = matrix4x4(((-5,2,6,-8), (1,-5,1,8), (7,7,-6,-7), (1,-3,7,4)))
        let i = m.inverse

        expect(m.determinant) == 532
        expect(m.cofactor(2, 3)) == -160
        expect(i[3, 2]) == -160/532
        expect(m.cofactor(3, 2)) == 105
        expect(i[2, 3]) == 105/532
        expect(i.approximate(digits: 5)) == matrix4x4((
            ( 0.21805,  0.45113,  0.24060, -0.04511),
            (-0.80827, -1.45677, -0.44361,  0.52068),
            (-0.07895, -0.22368, -0.05263,  0.19737),
            (-0.52256, -0.81391, -0.30075,  0.30639)
        ))
    }

    func test_inverse_of_matrix_extra_case_1() {
        let m = matrix4x4(((8,-5,9,2), (7,5,6,1), (-6,0,9,6), (-3,0,-9,-4)))

        expect(m.inverse.approximate(digits: 5)) == matrix4x4((
            (-0.15385, -0.15385, -0.28205, -0.53846),
            (-0.07692,  0.12308,  0.02564,  0.03077),
            ( 0.35897,  0.35897,  0.43590,  0.92308),
            (-0.69231, -0.69231, -0.76923, -1.92308)
        ))
    }

    func test_inverse_of_matrix_extra_case_2() {
        let m = matrix4x4(((9,3,0,9), (-5,-2,-6,-3), (-4,9,6,4), (-7,6,6,2)))

        expect(m.inverse.approximate(digits: 5)) == matrix4x4((
            (-0.04074, -0.07778,  0.14444, -0.22222),
            (-0.07778,  0.03333,  0.36667, -0.33333),
            (-0.02901, -0.14630, -0.10926,  0.12963),
            ( 0.17778,  0.06667, -0.26667,  0.33333)
        ))
    }

    func test_multiplying_a_product_by_its_inverse() {
        let a = matrix4x4(((3,-9,7,3), (3,-8,2,-9), (-4,4,4,1), (-6,5,-1,1)))
        let b = matrix4x4(((8,2,2,2), (3,-1,7,0), (7,0,5,4), (6,-2,0,5)))
        let c = a * b

        expect((c * b.inverse).approximate(digits: 5)) == a
    }
}
