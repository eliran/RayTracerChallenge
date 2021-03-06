//
// Created by Eliran Ben-Ezra on 2019-04-13.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import Foundation

extension Matrix {
    static func translation(x: Double, y: Double, z: Double) -> Matrix {
        return matrix4x4((
            (1,0,0,x),
            (0,1,0,y),
            (0,0,1,z),
            (0,0,0,1)
        ))
    }

    static func scaling(x: Double, y: Double, z: Double) -> Matrix {
        return matrix4x4((
            (x,0,0,0),
            (0,y,0,0),
            (0,0,z,0),
            (0,0,0,1)
        ))
    }

    static func rotation(x radians: Double) -> Matrix {
        return matrix4x4((
            (1,0,0,0),
            (0,cos(radians),-sin(radians),0),
            (0,sin(radians), cos(radians),0),
            (0,0,0,1)
        ))
    }

    static func rotation(y radians: Double) -> Matrix {
        return matrix4x4((
            (cos(radians),0,sin(radians),0),
            (0,1,0,0),
            (-sin(radians),0,cos(radians),0),
            (0,0,0,1)
        ))
    }

    static func rotation(z radians: Double) -> Matrix {
        return matrix4x4((
            (cos(radians),-sin(radians),0,0),
            (sin(radians),cos(radians),0,0),
            (0,0,1,0),
            (0,0,0,1)
        ))
    }

    static func shearing(xy: Double, xz: Double, yx: Double, yz: Double, zx: Double, zy: Double) -> Matrix {
        return matrix4x4((
            (1,xy,xz,0),
            (yx,1,yz,0),
            (zx,zy,1,0),
            (0,0,0,1)
        ))
    }

    // Fluent API

    func translate(x: Double, y: Double, z: Double) -> Matrix {
        return Matrix.translation(x: x, y: y, z: z) * self
    }

    func scale(x: Double, y: Double, z: Double) -> Matrix {
        return Matrix.scaling(x: x, y: y, z: z) * self
    }

    func rotate(x radians: Double) -> Matrix {
        return Matrix.rotation(x: radians) * self
    }

    func rotate(y radians: Double) -> Matrix {
        return Matrix.rotation(y: radians) * self
    }

    func rotate(z radians: Double) -> Matrix {
        return Matrix.rotation(z: radians) * self
    }
}

extension Matrix {
    static func view(from eye: Point, to point: Point, up: Vector) -> Matrix {
        let forward = (point - eye).normal
        let left = forward.cross(up.normal)
        let trueUp = left.cross(forward)
        return matrix4x4((
            (left.x, left.y, left.z, 0),
            (trueUp.x, trueUp.y, trueUp.z, 0),
            (-forward.x, -forward.y, -forward.z, 0),
            (0,0,0,1)
        )) * translation(x: -eye.x, y: -eye.y, z: -eye.z)
    }
}
