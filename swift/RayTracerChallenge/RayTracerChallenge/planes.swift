//
// Created by Eliran Ben-Ezra on 2019-04-19.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import Foundation

class Plane: Renderable {
    override func intersects(transformedRay: Ray) -> [Intersection] {
      guard abs(transformedRay.direction.y) >= Double.EPSILON else { return [] }
      let t = -transformedRay.origin.y / transformedRay.direction.y
      return [intersection(t: t, object: self)]
    }

    override func localNormal(at localPoint: Point) -> Vector {
        return vector(x: 0, y: 1, z: 0)
    }
}

extension Shapes {
    static func plane() -> Plane {
        return Plane()
    }
}
