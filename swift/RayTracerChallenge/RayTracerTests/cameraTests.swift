//
// Created by Eliran Ben-Ezra on 2019-04-14.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import XCTest

class CameraTests: XCTestCase {
    func test_constructing_a_camera() {
        let hsize = 160.0
        let vsize = 120.0
        let fieldOfView = Double.pi / 2
        let c = Camera(hsize: hsize, vsize: vsize, fov: fieldOfView, transform: Matrix.identity4x4)

        expect(c.hsize) == hsize
        expect(c.vsize) == vsize
        expect(c.fov) == fieldOfView
        expect(c.transform) == Matrix.identity4x4
    }

    func test_the_pixel_size_for_a_horizontal_canvas() {
        let c = Camera(hsize: 200, vsize: 125, fov: .pi/2)
        expect(c.pixelSize) ~ 0.01
    }

    func test_the_pixel_size_for_a_vertical_canvas() {
        let c = Camera(hsize: 125, vsize: 200, fov: .pi/2)
        expect(c.pixelSize) ~ 0.01
    }

    func test_constructing_a_ray_through_the_center_of_the_canvas() {
        let c = Camera(hsize: 201, vsize: 101, fov: .pi/2)
        let r = c.rayTo(x: 100, y: 50)
        expect(r.origin) == point(x: 0, y: 0, z: 0)
        expect(r.direction) ~ vector(x: 0, y: 0, z: -1)
    }

    func test_constructing_a_ray_through__a_corner_of_the_canvas() {
        let c = Camera(hsize: 201, vsize: 101, fov: .pi/2)
        let r = c.rayTo(x: 0, y: 0)
        expect(r.origin) == point(x: 0, y: 0, z: 0)
        expect(r.direction) ~ vector(x: 0.66519, y: 0.33259, z: -0.66851)
    }

    func test_constructing_a_ray_when_the_camera_is_transformed() {
        let c = Camera(hsize: 201, vsize: 101, fov: .pi/2).set(transform: Matrix.translation(x: 0, y: -2, z: 5).rotate(y: .pi/4))
        let r = c.rayTo(x: 100, y: 50)
        expect(r.origin) == point(x: 0, y: 2, z: -5)
        expect(r.direction) ~ vector(x: 2.0.squareRoot()/2, y: 0, z: -(2.0.squareRoot())/2)
    }

    func test_rendering_a_world_with_a_camera() {
        let w = World.default()
        let c = Camera(
            hsize: 11,
            vsize: 11,
            fov: .pi/2,
            transform: .view(
                from: point(x: 0, y: 0, z: -5),
                to: point(x: 0, y: 0, z: 0),
                up: vector(x: 0, y: 1, z: 0)
            )
        )
        let image = c.render(world: w)

        expect(image[5, 5]) == color(r: 0.38066, g: 0.47583, b: 0.2855)
    }
}
