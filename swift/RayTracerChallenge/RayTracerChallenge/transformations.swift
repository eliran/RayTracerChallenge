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
}
