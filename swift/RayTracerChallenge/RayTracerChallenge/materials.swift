//
// Created by Eliran Ben-Ezra on 2019-04-14.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import Foundation

protocol ColorByPosition: DynamicEquatable {
  func at(_ point: Point, for object: Renderable?) -> Color
  func at(_ point: Point) -> Color
}

extension ColorByPosition {
  func at(_ point: Point) -> Color {
    return self.at(point, for: nil)
  }
}


struct Material {
    let color: ColorByPosition
    let ambient: Double
    let diffuse: Double
    let specular: Double
    let shininess: Double
}

extension Material {
    static func make(color: ColorByPosition = Color(r: 1, g: 1, b: 1), ambient: Double = 0.1, diffuse: Double = 0.9, specular: Double = 0.9, shininess: Double = 200) -> Material {
        return Material(color: color, ambient: ambient, diffuse: diffuse, specular: specular, shininess: shininess)
    }
}

extension Material: Equatable {
    public static func ==(lhs: Material, rhs: Material) -> Bool {
        return lhs.color.isEqual(other: rhs.color) &&
            lhs.ambient == rhs.ambient &&
            lhs.diffuse == rhs.diffuse &&
            lhs.specular == rhs.specular &&
            lhs.shininess == rhs.shininess
    }
}

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
