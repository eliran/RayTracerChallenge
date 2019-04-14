//
// Created by Eliran Ben-Ezra on 2019-04-14.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import Foundation

class World {
    private(set) var lights: [PointLight] = []
    private(set) var objects: [Sphere] = []

    @discardableResult
    func add(light: PointLight) -> World {
        self.lights.append(light)
        return self
    }

    @discardableResult
    func add(object: Sphere) -> World {
        self.objects.append(object)
        return self
    }
}


extension World {
    static func `default`() -> World {
        let light = Light.point(position: point(x: -10, y: 10, z: -10), intensity: color(r: 1, g: 1, b: 1))
        let s1 = sphere().set(material: .make(color: color(r: 0.8, g: 1.0, b: 0.6), diffuse: 0.7, specular: 0.2))
        let s2 = sphere().set(transform: .scaling(x: 0.5, y: 0.5, z: 0.5))

        return World().add(light: light).add(object: s1).add(object: s2)
    }
}
