//
// Created by Eliran Ben-Ezra on 2019-04-14.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import XCTest

class WorldTests: XCTestCase {
    func test_creating_a_world() {
        let w = World()

        expect(w.objects.isEmpty) == true
        expect(w.lights.isEmpty) == true
    }

    func test_default_world() {
        let w = World.default()

        let light = Light.point(position: point(x: -10, y: 10, z: -10), intensity: color(r: 1, g: 1, b: 1))
        let s1 = sphere().set(material: .make(color: color(r: 0.8, g: 1.0, b: 0.6), diffuse: 0.7, specular: 0.2))
        let s2 = sphere().set(transform: .scaling(x: 0.5, y: 0.5, z: 0.5))

        expect(w.lights.first) == light
        expect(w.objects).contains(s1)
        expect(w.objects).contains(s2)
    }
}
