//
// Created by Eliran Ben-Ezra on 2019-04-08.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import Foundation

struct Tuple {
    let x: Double
    let y: Double
    let z: Double
    let w: Double
}

func tuple(x: Double, y: Double, z: Double, w: Double) -> Tuple {
    return Tuple(x: x, y: y, z: z, w: w)
}

func point(x: Double, y: Double, z: Double) -> Tuple {
    return Tuple(x: x, y: y, z: z, w: 1.0)
}

func vector(x: Double, y: Double, z: Double) -> Tuple {
    return Tuple(x: x, y: y, z: z, w: 0.0)
}

extension Tuple {
    var isPoint: Bool { return w == 1.0 }
    var isVector: Bool { return w == 0.0 }
}

extension Tuple: Equatable {}

extension Tuple {
    static func +(lhs: Tuple, rhs: Tuple) -> Tuple {
        return tuple(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z, w: lhs.w + rhs.w)
    }

    static func -(lhs: Tuple, rhs: Tuple) -> Tuple {
        return tuple(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z, w: lhs.w - rhs.w)
    }

    static prefix func -(value: Tuple) -> Tuple {
        return tuple(x: -value.x, y: -value.y, z: -value.z, w: -value.w)
    }

    static func *(lhs: Tuple, rhs: Double) -> Tuple {
        return tuple(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs, w: lhs.w * rhs)
    }
}

extension Tuple {
    var magnitude: Double {
        return sqrt(x*x + y*y + z*z + w*w)
    }
}
