//
// Created by Eliran Ben-Ezra on 2019-04-10.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import XCTest

class TransformationsTest: XCTestCase {
    func test_multiplying_by_a_translation_matrix() {
        let t = Matrix.translation(x: 5, y: -3, z: 2)
        let p = point(x: -3, y: 4, z: 5)

        expect(t * p) == point(x: 2, y: 1, z: 7)
    }

    func test_multiplying_by_the_inverse_if_a_translation_matrix() {
        let t = Matrix.translation(x: 5, y: -3, z: 2).inverse
        let p = point(x: -3, y: 4, z: 5)

        expect(t * p) == point(x: -8, y: 7, z: 3)
    }

    func test_translation_does_not_affect_vectors() {
        let t = Matrix.translation(x: 5, y: -3, z: 2)
        let v = vector(x: -3, y: 4, z: 5)

        expect(t * v ) == v
    }

    func test_scaling_matrix_applied_to_a_point() {
        let t = Matrix.scaling(x: 2, y: 3, z: 4)
        let p = point(x: -4, y: 6, z: 8)

        expect(t * p) == point(x: -8, y: 18, z: 32)
    }

    func test_scaling_matrix_applied_to_a_vector() {
        let t = Matrix.scaling(x: 2, y: 3, z: 4)
        let v = vector(x: -4, y: 6, z: 8)

        expect(t * v) == vector(x: -8, y: 18, z: 32)
    }

    func test_multiplying_by_the_inverse_of_a_scaling_matrix() {
        let t = Matrix.scaling(x: 2, y: 3, z: 4).inverse
        let v = vector(x: -4, y: 6, z: 8)

        expect(t * v) == vector(x: -2, y: 2, z: 2)
    }
}
