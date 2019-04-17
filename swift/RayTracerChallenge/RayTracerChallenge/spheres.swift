//
// Created by Eliran Ben-Ezra on 2019-04-13.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import Foundation

class Sphere: Renderable {
    override func intersects(transformedRay: Ray) -> [Intersection] {
        let sphereToRay = transformedRay.origin - point(x: 0, y: 0, z: 0)
        let a = transformedRay.direction.dot(transformedRay.direction)
        let b = 2 * transformedRay.direction.dot(sphereToRay)
        let c = sphereToRay.dot(sphereToRay) - 1

        let discriminant = b*b - 4*a*c

        if discriminant < 0 {
            return []
        }

        let rootOfDiscriminant = discriminant.squareRoot()
        let t1 = (-b - rootOfDiscriminant) / (2*a)
        let t2 = (-b + rootOfDiscriminant) / (2*a)

        // Returning tangents in increasing order
        if (t1 < t2) {
            return [intersection(t: t1, object: self), intersection(t: t2, object: self)]
        }

        return [intersection(t: t2, object: self), intersection(t: t1, object: self)]
    }

    override func localNormal(at localPoint: Point) -> Vector {
        return localPoint - point(x: 0, y: 0, z: 0)
    }
}

func sphere() -> Sphere {
    return Sphere()
}
