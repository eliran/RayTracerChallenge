//  Created by Eliran Ben-Ezra on 2019-04-08.
//  Copyright © 2019 Threeplay Inc. All rights reserved.
//

import Foundation

let basePath = "/Users/eliranbe/Desktop/"

func set(canvas: Canvas, _ point: Tuple, color: Color) {
    canvas[Int(point.x), canvas.height - Int(point.y)] = color
}

print("Some matrices tests")

print("Inverse of identity matrix: \(Matrix.identity4x4.inverse)")
let m = matrix4x4(((1,2,3,4), (4,6,7,8), (9,9,11,12), (13,5,15,16)))
print("M * M.inverse = \((m * m.inverse).approximate(digits: 5))")

print("M.transpose.inverse = \(m.transposed.inverse)")
print("M.inverse.transpose = \(m.inverse.transposed)")

var i = Matrix.identity4x4
let t = tuple(x: 1, y: 2, z: 3, w: 4)
i[1, 1] = 2

print("t * modified identify = \(i * t)")


print("Chapter 4 Challenge: Clock")

let c4 = canvas(width: 300, height: 300)

(0..<12).forEach { hour in
    let angle = Double(hour) * .pi / 6
    let p = point(x: 0, y: 140, z: 0)

    let t = Matrix.identity4x4.rotate(z: angle).translate(x: 150, y: 150, z: 0)

    set(canvas: c4, t * p, color: color(r: 1, g: Double(hour)/12.0, b: 0))
}

try? c4.toPPM().write(toFile: "\(basePath)/ch4_clock.ppm", atomically: true, encoding: .utf8)


print("Starting projectile demo")

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

try? c.toPPM().write(toFile: "\(basePath)/projectile.ppm", atomically: true, encoding: .utf8)

print("Total ticks to hit the ground: \(projectileDemo.tickCount)")

