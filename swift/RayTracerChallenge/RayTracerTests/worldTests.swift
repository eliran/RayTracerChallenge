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
        let s1 = Shapes.sphere().set(material: .make(color: color(r: 0.8, g: 1.0, b: 0.6), diffuse: 0.7, specular: 0.2))
        let s2 = Shapes.sphere().set(transform: .scaling(x: 0.5, y: 0.5, z: 0.5))

        expect(w.lights.first) == light
        expect(w.objects).contains(s1)
        expect(w.objects).contains(s2)
    }

    func test_intersect_a_world_with_a_ray() {
        let w = World.default()
        let r = ray(origin: point(x: 0, y: 0, z: -5), direction: vector(x: 0, y: 0, z: 1))

        let xs = r.intersects(w)

        expect(xs.count) == 4
        expect(xs[0].t) == 4
        expect(xs[1].t) == 4.5
        expect(xs[2].t) == 5.5
        expect(xs[3].t) == 6
    }

    func test_precomputing_the_state_of_an_intersection() {
        let r = ray(origin: point(x: 0, y: 0, z: -5), direction: vector(x: 0, y: 0, z: 1))
        let s = Shapes.sphere()
        let i = intersection(t: 4, object: s)

        let c = i.prepare(for: r)

        expect(c.t) == i.t
        expect(c.object) == i.object
        expect(c.point) == point(x: 0, y: 0, z: -1)
        expect(c.eyev) == vector(x: 0, y: 0, z: -1)
        expect(c.normalv) == vector(x: 0, y: 0, z: -1)
    }

    func test_the_hit_when_an_intersection_occurs_on_the_outside() {
        let r = ray(origin: point(x: 0, y: 0, z: -5), direction: vector(x: 0, y: 0, z: 1))
        let s = Shapes.sphere()
        let i = intersection(t: 4, object: s)

        let c = i.prepare(for: r)

        expect(c.inside) == false
    }

    func test_the_his_when_an_intersection_occurs_on_the_inside() {
        let r = ray(origin: point(x: 0, y: 0, z: 0), direction: vector(x: 0, y: 0, z: 1))
        let s = Shapes.sphere()
        let i = intersection(t: 1, object: s)

        let c = i.prepare(for: r)

        expect(c.point) == point(x: 0, y: 0, z: 1)
        expect(c.eyev) == vector(x: 0, y: 0, z: -1)
        expect(c.inside) == true
        expect(c.normalv) == vector(x: 0, y: 0, z: -1)
    }

    func test_shading_an_intersection() {
        let w = World.default()
        let r = ray(origin: point(x: 0, y: 0, z: -5), direction: vector(x: 0, y: 0, z: 1))
        let s = w.objects.first!
        let i = intersection(t: 4, object: s)

        let c = w.shade(i.prepare(for: r))

        expect(c) == color(r: 0.38066, g: 0.47583, b: 0.2855)
    }

    func test_shading_an_intersection_from_the_inside() {
        let w = World.default().removeAllLights().add(light: Light.point(position: point(x: 0, y: 0.25, z: 0), intensity: color(r: 1, g: 1, b: 1)))
        let r = ray(origin: point(x: 0, y: 0, z: 0), direction: vector(x: 0, y: 0, z: 1))
        let s = w.objects.last!
        let i = intersection(t: 0.5, object: s)

        let c = w.shade(i.prepare(for: r))

        expect(c) == color(r: 0.1, g: 0.1, b: 0.1) // color(r: 0.90498, g: 0.90498, b: 0.90498)
    }

    func test_color_when_a_ray_misses() {
        let w = World.default()
        let r = ray(origin: point(x: 0, y: 0, z: -5), direction: vector(x: 0, y: 1, z: 0))
        expect(w.color(for: r)) == color(r: 0, g: 0, b: 0)
    }

    func test_color_when_a_ray_hits() {
        let w = World.default()
        let r = ray(origin: point(x: 0, y: 0, z: -5), direction: vector(x: 0, y: 0, z: 1))

        expect(w.color(for: r)) == color(r: 0.38066, g: 0.47583, b: 0.2855)
    }

    func test_color_with_a_intersection_behind_the_ray() {
        let w = World.default()
        let _ = w.objects.first!.updateMaterial { $0.copy(ambient: 1) }
        let i = w.objects.last!.updateMaterial { $0.copy(ambient: 1) }
        let r = ray(origin: point(x: 0, y: 0, z: 0.75), direction: vector(x: 0, y: 0, z: -1))

        expect(w.color(for: r)) == i.material.color.at(point(x: 0, y: 0, z: 0))
    }

    func test_there_is_no_shadow_when_nothing_is_collinear_with_point_and_light() {
        let w = World.default()
        let p = point(x: 0, y: 10, z: 0)

        expect(w.isShadowed(point: p)) == false
    }

    func test_the_shadow_when_an_object_is_between_the_point_and_the_light() {
        let w = World.default()
        let p = point(x: 10, y: -10, z: 10)

        expect(w.isShadowed(point: p)) == true
    }

    func test_there_is_no_shadow_when_an_object_is_behind_the_light() {
        let w = World.default()
        let p = point(x: -20, y: 20, z: -20)

        expect(w.isShadowed(point: p)) == false
    }

    func test_there_is_no_shadow_when_an_object_is_behind_the_point() {
        let w = World.default()
        let p = point(x: -2, y: 2, z: -2)

        expect(w.isShadowed(point: p)) == false
    }

    func test_shade_hit_is_given_an_intersection_in_shadow() {
        let w = World().add(light: Light.point(position: point(x: 0, y: 0, z: -10), intensity: color(r: 1, g: 1, b: 1)))
        let s1 = Shapes.sphere()
        let s2 = Shapes.sphere().set(transform: .translation(x: 0, y: 0, z: 10))
        let r = ray(origin: point(x: 0, y: 0, z: 5), direction: vector(x: 0, y: 0, z: 1))
        let i = intersection(t: 4, object: s2)

        w.add(objects: s1, s2)

        expect(w.shade(i.prepare(for: r))) == color(r: 0.1, g: 0.1, b: 0.1)
    }
}
