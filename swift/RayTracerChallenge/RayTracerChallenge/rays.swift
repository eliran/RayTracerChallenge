//
// Created by Eliran Ben-Ezra on 2019-04-13.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import Foundation

struct Ray {
    let origin: Point
    let direction: Vector
}

func ray(origin: Point, direction: Vector) -> Ray {
    return Ray(origin: origin, direction: direction)
}


extension Ray {
    func position(_ t: Double) -> Point {
        return origin + direction * t
    }
}
