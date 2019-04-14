//
// Created by Eliran Ben-Ezra on 2019-04-08.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import Foundation

protocol ApproximationEquals: Equatable {
    func approximate(digits: Int) -> Self
}

struct Tuple {
    let x: Double
    let y: Double
    let z: Double
    let w: Double
}

typealias Vector = Tuple
typealias Point = Tuple

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

    var normal: Tuple {
        let magnitude = self.magnitude
        return tuple(x: x / magnitude, y: y / magnitude, z: z / magnitude, w: w / magnitude)
    }
}

extension Tuple {
    func dot(_ other: Tuple) -> Double {
        return x * other.x + y * other.y + z * other.z + w * other.w
    }

    func cross(_ other: Tuple) -> Tuple {
        return vector(
            x: y * other.z - z * other.y,
            y: z * other.x - x * other.z,
            z: x * other.y - y * other.x)
    }
}

extension Tuple: ApproximationEquals {
    func approximate(digits: Int) -> Tuple {
        let multiplier = Double.approximateMultiplier(digits: digits)

        return vector(
            x: x.approximate(multiplier: multiplier),
            y: y.approximate(multiplier: multiplier),
            z: z.approximate(multiplier: multiplier)
        )
    }
}

extension Double {
    static func approximateMultiplier(digits: Int) -> Double {
        return pow(10, Double(digits))
    }

    func approximate(multiplier: Double) -> Double {
        var preround = self * multiplier
        preround.round()
        return preround / multiplier
    }
}

extension Tuple {
    func set(w: Double) -> Tuple {
        return Tuple(x: x, y: y, z: z, w: w)
    }
}

extension Tuple {
    func reflect(around normal: Vector) -> Tuple {
        return self - normal * 2 * self.dot(normal)
    }
}
