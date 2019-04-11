//  Created by Eliran Ben-Ezra on 2019-04-08.
//  Copyright © 2019 Threeplay Inc. All rights reserved.
//

import Foundation

func set(canvas: Canvas, _ point: Tuple, color: Color) {
    canvas[Int(point.x), canvas.height - Int(point.y)] = color
}

print("Hello, World!")


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

try? c.toPPM().write(toFile: "/Users/eliranbe/Desktop/projectile.ppm", atomically: true, encoding: .utf8)

print("Total ticks to hit the ground: \(projectileDemo.tickCount)")

