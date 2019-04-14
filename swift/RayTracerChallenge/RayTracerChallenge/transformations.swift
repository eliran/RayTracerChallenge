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
}
