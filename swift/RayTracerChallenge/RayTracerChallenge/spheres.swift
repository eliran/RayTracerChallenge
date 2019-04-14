//
// Created by Eliran Ben-Ezra on 2019-04-13.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import Foundation

struct Sphere {
}

extension Sphere: Equatable {}

func sphere() -> Sphere {
    return Sphere()
}

extension Ray {
    func intersects(_ sphere: Sphere) -> [Intersection<Sphere>] {
        let sphereToRay = origin - point(x: 0, y: 0, z: 0)
        let a = direction.dot(direction)
        let b = 2 * direction.dot(sphereToRay)
        let c = sphereToRay.dot(sphereToRay) - 1

        let discriminant = b*b - 4*a*c

        if discriminant < 0 {
            return []
        }

        let t1 = (-b - discriminant.squareRoot()) / (2*a)
        let t2 = (-b + discriminant.squareRoot()) / (2*a)

        // Returning tangents in increasing order
        if (t1 < t2) {
            return [intersection(t: t1, object: sphere), intersection(t: t2, object: sphere)]
        }

        return [intersection(t: t2, object: sphere), intersection(t: t1, object: sphere)]
    }
}
