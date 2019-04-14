//
// Created by Eliran Ben-Ezra on 2019-04-14.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import Foundation

struct Material {
    let color: Color
    let ambient: Double
    let diffuse: Double
    let specular: Double
    let shininess: Double
}

extension Material {
    static func make(color: Color = Color(r: 1, g: 1, b: 1), ambient: Double = 0.1, diffuse: Double = 0.9, specular: Double = 0.9, shininess: Double = 200) -> Material {
        return Material(color: color, ambient: ambient, diffuse: diffuse, specular: specular, shininess: shininess)
    }
}

extension Material: Equatable {}

extension Material {
    func copy(color: Color? = nil, ambient: Double? = nil, diffuse: Double? = nil, specular: Double? = nil, shininess: Double? = nil) -> Material {
        return Material(
            color: color ?? self.color,
            ambient: ambient ?? self.ambient,
            diffuse: diffuse ?? self.diffuse,
            specular: specular ?? self.specular,
            shininess: shininess ?? self.shininess)
    }
}
