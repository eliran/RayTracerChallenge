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
        return []
    }

    func normal(at position: Point) -> Vector {
        let invertedTransform = transform.inverse
        let objectPosition = invertedTransform * position
        let objectNormal = objectPosition - point(x: 0, y: 0, z: 0)
        return (invertedTransform.transposed * objectNormal).set(w: 0).normal
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
