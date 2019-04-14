//
// Created by Eliran Ben-Ezra on 2019-04-13.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import Foundation

struct Ray {
    let origin: Point
    let direction: Vector
}

struct Intersection<O: Equatable> {
    let t: Double
    let object: O
}

func ray(origin: Point, direction: Vector) -> Ray {
    return Ray(origin: origin, direction: direction)
}


func intersection<O>(t: Double, object: O) -> Intersection<O> {
    return Intersection(t: t, object: object)
}

func intersections<O>(_ intersections: Intersection<O>...) -> [Intersection<O>] {
    return intersections
}

extension Ray {
    func position(_ t: Double) -> Point {
        return origin + direction * t
    }
}

extension Ray {
    func transform(_ matrix: Matrix) -> Ray {
        return Ray(origin: matrix * origin, direction: matrix * direction)
    }
}

extension Intersection: Equatable {}

func hit<O>(_ intersections: [Intersection<O>]) -> Intersection<O>? {
    var bestIntersection: Intersection<O>? = nil
    for i in intersections where i.t >= 0 {
        if bestIntersection == nil {
            bestIntersection = i
        } else if let best = bestIntersection, best.t > i.t {
            bestIntersection = i
        }
    }
    return bestIntersection
}
