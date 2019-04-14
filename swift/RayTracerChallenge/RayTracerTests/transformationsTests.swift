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

    func test_reflection_is_scaling_by_a_negative_value() {
        let t = Matrix.scaling(x: -1, y: 1, z: 1)
        let p = point(x: 2, y: 3, z: 4)

        expect(t * p) == point(x: -2, y: 3, z: 4)
    }

    func test_rotating_a_point_around_the_x_axis() {
        let p = point(x: 0, y: 1, z: 0)
        let hq = Matrix.rotation(x: .pi / 4)
        let fq = Matrix.rotation(x: .pi / 2)

        expect(hq * p) ~ point(x: 0, y: 2.0.squareRoot()/2, z: 2.0.squareRoot()/2)
        expect(fq * p) ~ point(x: 0, y: 0, z: 1)
    }

    func test_inverse_of_x_rotation_rotates_in_the_opposite_direction() {
        let p = point(x: 0, y: 1, z: 0)
        let ihq = Matrix.rotation(x: .pi / 4).inverse

        expect(ihq * p) ~ point(x: 0, y: 2.0.squareRoot()/2, z: -2.0.squareRoot()/2)
    }

    func test_rotation_a_point_around_the_y_axis() {
        let p = point(x: 0, y: 0, z: 1)
        let hq = Matrix.rotation(y: .pi / 4)
        let fq = Matrix.rotation(y: .pi / 2)

        expect(hq * p) ~ point(x: 2.0.squareRoot()/2, y: 0, z: 2.0.squareRoot()/2)
        expect(fq * p) ~ point(x: 1, y: 0, z: 0)
    }

    func test_rotation_a_point_around_the_z_axis() {
        let p = point(x: 0, y: 1, z: 0)
        let hq = Matrix.rotation(z: .pi / 4)
        let fq = Matrix.rotation(z: .pi / 2)

        expect(hq * p) ~ point(x: -2.0.squareRoot()/2, y: 2.0.squareRoot()/2, z: 0)
        expect(fq * p) ~ point(x: -1, y: 0, z: 0)
    }

    func test_shearing_transformation_moves_x_in_proportion_to_y() {
        let t = Matrix.shearing(xy: 1, xz: 0, yx: 0, yz: 0, zx: 0, zy: 0)
        let p = point(x: 2, y: 3, z: 4)

        expect(t * p) == point(x: 5, y: 3, z: 4)
    }

    func test_shearing_transformation_moves_x_in_proportion_to_z() {
        let t = Matrix.shearing(xy: 0, xz: 1, yx: 0, yz: 0, zx: 0, zy: 0)
        let p = point(x: 2, y: 3, z: 4)

        expect(t * p) == point(x: 6, y: 3, z: 4)
    }

    func test_shearing_transformation_moves_y_in_proportion_to_x() {
        let t = Matrix.shearing(xy: 0, xz: 0, yx: 1, yz: 0, zx: 0, zy: 0)
        let p = point(x: 2, y: 3, z: 4)

        expect(t * p) == point(x: 2, y: 5, z: 4)
    }

    func test_shearing_transformation_moves_y_in_proportion_to_z() {
        let t = Matrix.shearing(xy: 0, xz: 0, yx: 0, yz: 1, zx: 0, zy: 0)
        let p = point(x: 2, y: 3, z: 4)

        expect(t * p) == point(x: 2, y: 7, z: 4)
    }

    func test_shearing_transformation_moves_z_in_proportion_to_x() {
        let t = Matrix.shearing(xy: 0, xz: 0, yx: 0, yz: 0, zx: 1, zy: 0)
        let p = point(x: 2, y: 3, z: 4)

        expect(t * p) == point(x: 2, y: 3, z: 6)
    }

    func test_shearing_transformation_moves_z_in_proportion_to_y() {
        let t = Matrix.shearing(xy: 0, xz: 0, yx: 0, yz: 0, zx: 0, zy: 1)
        let p = point(x: 2, y: 3, z: 4)

        expect(t * p) == point(x: 2, y: 3, z: 7)
    }
}
