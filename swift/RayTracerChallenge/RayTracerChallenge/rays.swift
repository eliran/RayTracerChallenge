//
// Created by Eliran Ben-Ezra on 2019-04-13.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import Foundation

struct Ray {
    let origin: Point
    let direction: Vector
}

struct Intersection {
    let t: Double
    let object: Renderable
}

func ray(origin: Point, direction: Vector) -> Ray {
    return Ray(origin: origin, direction: direction)
}


func intersection(t: Double, object: Renderable) -> Intersection {
    return Intersection(t: t, object: object)
}

func intersections(_ intersections: Intersection...) -> [Intersection] {
    return intersections
}

extension Ray {
    func position(_ t: Double) -> Point {
        return origin + direction * t
    }

    func transform(_ matrix: Matrix) -> Ray {
        return Ray(origin: matrix * origin, direction: matrix * direction)
    }

    func intersects(_ object: Renderable) -> [Intersection] {
        return object.intersects(ray: self)
    }
}

extension Intersection: Equatable {}

extension Sequence where Element == Intersection {
    var hit: Intersection? {
        var bestIntersection: Intersection? = nil
        for i in self where i.t >= 0 {
            if bestIntersection == nil {
                bestIntersection = i
            } else if let best = bestIntersection, best.t > i.t {
                bestIntersection = i
            }
        }
        return bestIntersection
    }
}

func hit(_ intersections: [Intersection]) -> Intersection? {
    return intersections.hit
}
