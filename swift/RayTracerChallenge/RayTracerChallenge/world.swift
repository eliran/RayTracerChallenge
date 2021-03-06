//
// Created by Eliran Ben-Ezra on 2019-04-14.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import Foundation

class World {
    private(set) var lights: [PointLight] = []
    private(set) var objects: [Renderable] = []

    @discardableResult
    func add(light: PointLight) -> World {
        self.lights.append(light)
        return self
    }

    @discardableResult
    func add(object: Renderable) -> World {
        self.objects.append(object)
        return self
    }

    @discardableResult
    func add(objects: Renderable...) -> World {
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
        let s1 = Shapes.sphere().set(material: .make(color: Color(r: 0.8, g: 1.0, b: 0.6), diffuse: 0.7, specular: 0.2))
        let s2 = Shapes.sphere().set(transform: .scaling(x: 0.5, y: 0.5, z: 0.5))

        return World().add(light: light).add(object: s1).add(object: s2)
    }
}

extension Ray {
    func intersects(_ world: World) -> [Intersection] {
        return world.objects.reduce([]) { $0 + self.intersects($1) }.sorted { $0.t < $1.t }
    }
}

extension World {
    func shade(_ precalcs: IntersectionComputation) -> Color {
        return lights.reduce(Color(r: 0, g: 0, b: 0)) {
           $0 + precalcs.object.material.lighting(
               light: $1,
               position: precalcs.point,
               eye: precalcs.eyev,
               normal: precalcs.normalv,
               inShadow: isShadowed(point: precalcs.overPoint, light: $1)
           )
        }
    }

    func color(for ray: Ray) -> Color {
        if let h = ray.intersects(self).hit {
            return shade(h.prepare(for: ray))
        }
        return Color(r: 0, g: 0, b: 0)
    }

    func isShadowed(point: Point, light: PointLight? = nil) -> Bool {
        guard let light = light ?? self.lights.first else {
            return false
        }

        let v = light.position - point
        let distance = v.magnitude
        let direction = v.normal

        if let h = ray(origin: point, direction: direction).intersects(self).hit, h.t < distance {
            return true
        }
        return false
    }
}
