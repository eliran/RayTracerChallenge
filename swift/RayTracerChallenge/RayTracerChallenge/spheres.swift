//
// Created by Eliran Ben-Ezra on 2019-04-13.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import Foundation

class Sphere {
    private(set) var transform: Matrix = Matrix.identity4x4
}

extension Sphere: Equatable {
    public static func ==(lhs: Sphere, rhs: Sphere) -> Bool {
        return lhs.transform == rhs.transform
    }
}

func sphere() -> Sphere {
    return Sphere()
}

extension Sphere {
    @discardableResult
    func set(transform: Matrix) -> Sphere {
        self.transform = transform
        return self
    }
}

extension Sphere {
    func normal(at position: Point) -> Vector {
        let invertedTransform = transform.inverse
        let objectPosition = invertedTransform * position
        let objectNormal = objectPosition - point(x: 0, y: 0, z: 0)
        return (invertedTransform.transposed * objectNormal).set(w: 0).normal
    }
}

extension Ray {
    func intersects(_ sphere: Sphere) -> [Intersection<Sphere>] {
        let transformedRay = self.transform(sphere.transform.inverse)

        let sphereToRay = transformedRay.origin - point(x: 0, y: 0, z: 0)
        let a = transformedRay.direction.dot(transformedRay.direction)
        let b = 2 * transformedRay.direction.dot(sphereToRay)
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