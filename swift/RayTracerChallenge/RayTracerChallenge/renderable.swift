//
// Created by Eliran Ben-Ezra on 2019-04-17.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import Foundation

open class Renderable {
    private(set) var transform: Matrix = Matrix.identity4x4
    private(set) var material: Material = Material.make()

    @discardableResult
    func set(transform: Matrix) -> Self {
        self.transform = transform
        return self
    }

    @discardableResult
    func set(material: Material) -> Self {
        self.material = material
        return self
    }

    @discardableResult
    func updateMaterial(_ updateBlock: (Material) -> Material) -> Self {
        self.material = updateBlock(self.material)
        return self
    }

    func intersects(ray: Ray) -> [Intersection] {
        return intersects(transformedRay: ray.transform(self.transform.inverse))
    }

    func intersects(transformedRay: Ray) -> [Intersection] {
        return []
    }

    func normal(at position: Point) -> Vector {
        let invertedTransform = transform.inverse
        let localNormal = self.localNormal(at: invertedTransform * position)
        return (invertedTransform.transposed * localNormal).set(w: 0).normal
    }

    func localNormal(at localPoint: Point) -> Vector {
        return vector(x: localPoint.x, y: localPoint.y, z: localPoint.z)
    }
}

extension Renderable: Equatable {
    public static func == (lhs: Renderable, rhs: Renderable) -> Bool {
        return lhs.transform == rhs.transform
    }
}

struct IntersectionComputation {
    let t: Double
    let object: Renderable
    let point: Point
    let eyev: Vector
    let normalv: Vector
    let inside: Bool
    let overPoint: Point
}

extension Double {
    static let EPSILON = 0.0001
}

extension Intersection {
    func prepare(for ray: Ray) -> IntersectionComputation {
        let p = ray.position(t)
        let n = object.normal(at: p)
        let e = -ray.direction
        let inside = n.dot(e) < 0
        let overPoint = p + n*Double.EPSILON
        return IntersectionComputation(
            t: t,
            object: object,
            point: p,
            eyev: e,
            normalv: inside ? -n : n,
            inside: inside,
            overPoint: overPoint
        )
    }
}
