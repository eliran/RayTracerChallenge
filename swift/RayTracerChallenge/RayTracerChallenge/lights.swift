//
// Created by Eliran Ben-Ezra on 2019-04-14.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import Foundation

enum Light {
    static func point(position: Point, intensity: Color) -> PointLight {
        return PointLight(position: position, intensity: intensity)
    }
}

struct PointLight {
    let position: Point
    let intensity: Color
}

extension PointLight: Equatable {}

extension Material {
    func lighting(light: PointLight, position: Point, eye: Vector, normal: Vector) -> Color {
        let effectiveColor = color * light.intensity
        let lightVector = (light.position - position).normal
        let ambient = effectiveColor * self.ambient

        let lightDotNormal = lightVector.dot(normal)

        let diffuse: Color
        let specular: Color
        if lightDotNormal < 0 {
            diffuse = Color(r: 0, g: 0, b: 0)
            specular = Color(r: 0, g: 0, b: 0)
        } else {
            diffuse = effectiveColor * self.diffuse * lightDotNormal

            let reflectVector = (-lightVector).reflect(around: normal)
            let reflectDotEye = reflectVector.dot(eye)

            if reflectDotEye <= 0 {
                specular = Color(r: 0, g: 0, b: 0)
            } else {
                specular = light.intensity * self.specular * pow(reflectDotEye, self.shininess)
            }
        }
        return ambient + diffuse + specular
    }
}
