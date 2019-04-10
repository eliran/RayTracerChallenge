//  Created by Eliran Ben-Ezra on 2019-04-08.
//  Copyright © 2019 Threeplay Inc. All rights reserved.
//

import Foundation

print("Hello, World!")


print("Starting projectile demo")

let projectileDemo = ProjectileSimulation(
    initialPosition: point(x: 0, y: 10, z: 0),
    initialVelocity: vector(x: 1, y: 1, z: 0),
    wind: vector(x: -0.01, y: 0, z: 0),
    gravity: vector(x: 0, y: -0.1, z: 0))

while projectileDemo.projectile.position.y > 0 {
    print("Projectile Position: \(projectileDemo.projectile.position.approximate(digits: 2)) velocity: \(projectileDemo.projectile.velocity.approximate(digits: 2))")
    projectileDemo.tick()
}

print("Total ticks to hit the ground: \(projectileDemo.tickCount)")
