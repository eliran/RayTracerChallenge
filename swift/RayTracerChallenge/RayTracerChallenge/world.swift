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

    @discardableResult
    func add(objects: Sphere...) -> World {
        self.objects.append(contentsOf: objects)
        return self
    }

    @discardableResult
    func removeAllLights() -> World {
        self.lights.removeAll()
        return self
    }
}


extension World {
    static func `default`() -> World {
        let light = Light.point(position: point(x: -10, y: 10, z: -10), intensity: Color(r: 1, g: 1, b: 1))
        let s1 = sphere().set(material: .make(color: Color(r: 0.8, g: 1.0, b: 0.6), diffuse: 0.7, specular: 0.2))
        let s2 = sphere().set(transform: .scaling(x: 0.5, y: 0.5, z: 0.5))

        return World().add(light: light).add(object: s1).add(object: s2)
    }
}

extension Ray {
    func intersects(_ world: World) -> [Intersection<Sphere>] {
        return world.objects.reduce([]) { $0 + self.intersects($1) }.sorted { $0.t < $1.t }
    }
}

extension World {
    func shade(_ precalcs: IntersectionComputation<Sphere>) -> Color {
        return lights.reduce(Color(r: 0, g: 0, b: 0)) {
           $0 + precalcs.object.material.lighting(light: $1, position: precalcs.point, eye: precalcs.eyev, normal: precalcs.normalv)
        }
    }

    func color(for ray: Ray) -> Color {
        if let h = hit(ray.intersects(self)) {
            return shade(h.prepare(for: ray))
        }
        return Color(r: 0, g: 0, b: 0)
    }
}
