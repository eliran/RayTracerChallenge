//
// Created by Eliran Ben-Ezra on 2019-04-14.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import XCTest

class MaterialsTests: XCTestCase {
    func test_the_default_material() {
        let m = Material.make()

        expect(m.color) == color(r: 1, g: 1, b: 1)
        expect(m.ambient) == 0.1
        expect(m.diffuse) == 0.9
        expect(m.specular) == 0.9
        expect(m.shininess) == 200.0
    }
}

class LightingTests: XCTestCase {
    var m: Material!
    var p: Point!

    override func setUp() {
        m = Material.make()
        p = point(x: 0, y: 0, z: 0)
    }

    func test_lighting_with_the_eye_between_the_light_and_the_surface() {
        let eyev = vector(x: 0, y: 0, z: -1)
        let normalv = vector(x: 0, y: 0, z: -1)
        let light = Light.point(position: point(x: 0, y: 0, z: -10), intensity: color(r: 1, g: 1, b: 1))

        expect(m.lighting(light: light, position: p, eye: eyev, normal: normalv)) == color(r: 1.9, g: 1.9, b: 1.9)
    }

    func test_lighting_with_the_eye_between_the_light_and_the_surface_eye_offset_45_degrees() {
        let eyev = vector(x: 0, y: 2.0.squareRoot()/2, z: -(2.0.squareRoot()/2))
        let normalv = vector(x: 0, y: 0, z: -1)
        let light = Light.point(position: point(x: 0, y: 0, z: -10), intensity: color(r: 1, g: 1, b: 1))

        expect(m.lighting(light: light, position: p, eye: eyev, normal: normalv)) == color(r: 1, g: 1, b: 1)
    }

    func test_lighting_with_the_eye_opposite_surface_light_offset_45_degrees() {
        let eyev = vector(x: 0, y: 0, z: -1)
        let normalv = vector(x: 0, y: 0, z: -1)
        let light = Light.point(position: point(x: 0, y: 10, z: -10), intensity: color(r: 1, g: 1, b: 1))

        expect(m.lighting(light: light, position: p, eye: eyev, normal: normalv)) == color(r: 0.7364, g: 0.7364, b: 0.7364)
    }

    func test_lighting_with_the_eye_in_the_path_of_the_reflection_vector() {
        let eyev = vector(x: 0, y: -(2.0.squareRoot()/2), z: -(2.0.squareRoot()/2))
        let normalv = vector(x: 0, y: 0, z: -1)
        let light = Light.point(position: point(x: 0, y: 10, z: -10), intensity: color(r: 1, g: 1, b: 1))

        expect(m.lighting(light: light, position: p, eye: eyev, normal: normalv)) == color(r: 1.6364, g: 1.6364, b: 1.6364)
    }

    func test_lighting_with_light_behind_the_surface() {
        let eyev = vector(x: 0, y: 0, z: -1)
        let normalv = vector(x: 0, y: 0, z: -1)
        let light = Light.point(position: point(x: 0, y: 0, z: 10), intensity: color(r: 1, g: 1, b: 1))

        expect(m.lighting(light: light, position: p, eye: eyev, normal: normalv)) == color(r: 0.1, g: 0.1, b: 0.1)
    }

}
