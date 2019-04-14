//  Created by Eliran Ben-Ezra on 2019-04-08.
//  Copyright © 2019 Threeplay Inc. All rights reserved.
//

import Foundation

let basePath = "/Users/eliranbe/Desktop/"

func set(canvas: Canvas, _ point: Tuple, color: Color) {
    canvas[Int(point.x), canvas.height - Int(point.y)] = color
}

extension Demo {
    static func run(basePath: String) {
        let path = "\(basePath)/\(String(describing: self)).ppm"

        print(name)
        try? invoke()?.toPPM().write(toFile: path, atomically: true, encoding: .utf8)
    }
}

protocol Demo {
    static var name: String { get }
    static func invoke() -> Canvas?
}

class MatricesDemo: Demo {
    static let name = "Some matrices tests"

    static func invoke() -> Canvas? {
        print("Inverse of identity matrix: \(Matrix.identity4x4.inverse)")
        let m = matrix4x4(((1,2,3,4), (4,6,7,8), (9,9,11,12), (13,5,15,16)))
        print("M * M.inverse = \((m * m.inverse).approximate(digits: 5))")

        print("M.transpose.inverse = \(m.transposed.inverse)")
        print("M.inverse.transpose = \(m.inverse.transposed)")

        var i = Matrix.identity4x4
        let t = tuple(x: 1, y: 2, z: 3, w: 4)
        i[1, 1] = 2

        print("t * modified identify = \(i * t)")
        return nil
    }
}


class Chapter4Clock: Demo {
    static let name = "Chapter 4 Challenge: Clock"

    static func invoke() -> Canvas? {
        let c = canvas(width: 300, height: 300)

        (0..<12).forEach { hour in
            let angle = Double(hour) * .pi / 6
            let p = point(x: 0, y: 140, z: 0)

            let t = Matrix.identity4x4.rotate(z: angle).translate(x: 150, y: 150, z: 0)

            set(canvas: c, t * p, color: color(r: 1, g: Double(hour)/12.0, b: 0))
        }

        return c
    }
}

//try? c4.toPPM().write(toFile: "\(basePath)/ch4_clock.ppm", atomically: true, encoding: .utf8)

class ProjectileDemo: Demo {
    static let name = "Starting projectile demo"

    static func invoke() -> Canvas? {
        let projectileDemo = ProjectileSimulation(
            initialPosition: point(x: 0, y: 1, z: 0),
            initialVelocity: vector(x: 1, y: 1.8, z: 0).normal * 11.25,
            wind: vector(x: -0.01, y: 0, z: 0),
            gravity: vector(x: 0, y: -0.1, z: 0))

        let c = canvas(width: 900, height: 550)

        while projectileDemo.projectile.position.y > 0 {
            print("Projectile Position: \(projectileDemo.projectile.position.approximate(digits: 2)) velocity: \(projectileDemo.projectile.velocity.approximate(digits: 2))")
            set(canvas: c, projectileDemo.projectile.position, color: color(r: 1, g: 0, b: 0))
            projectileDemo.tick()
        }

        print("Total ticks to hit the ground: \(projectileDemo.tickCount)")

        return c
    }
}

class Chapter5Demo: Demo {
    static let name = "Ray cast a sphere"

    static func invoke() -> Canvas? {

        let s = sphere().set(transform: Matrix.shearing(xy: 1, xz: 0, yx: 0, yz: 0, zx: 0, zy: 0) * Matrix.scaling(x: 0.5, y: 1, z: 1))

        let origin = point(x: 0, y: 0, z: -5)
        let wall_z = 10.0
        let wall_size = 7.0
        let canvas_pixels = 200
        let pixel_size = wall_size / Double(canvas_pixels)
        let half = wall_size / 2

        let c = canvas(width: canvas_pixels, height: canvas_pixels)

        for y in 0..<canvas_pixels {
            let world_y = half - pixel_size * Double(y)
            for x in 0..<canvas_pixels {
                let world_x = -half + pixel_size * Double(x)

                let wall_position = point(x: world_x, y: world_y, z: wall_z)

                let r = ray(origin: origin, direction: (wall_position - origin).normal)

                if hit(r.intersects(s)) != nil {
                    set(canvas: c, point(x: Double(x), y: Double(y), z: 0), color: color(r: 1, g: 0, b: 1))
                }
            }
        }

        return c
    }
}

//MatricesDemo.run(basePath: basePath)
//Chapter4Clock.run(basePath: basePath)
//ProjectileDemo.run(basePath: basePath)
Chapter5Demo.run(basePath: basePath)


