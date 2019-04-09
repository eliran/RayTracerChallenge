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

extension Tuple {
    var isPoint: Bool { return w == 1.0 }
    var isVector: Bool { return w == 0.0 }
}

extension Tuple: Equatable {
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
