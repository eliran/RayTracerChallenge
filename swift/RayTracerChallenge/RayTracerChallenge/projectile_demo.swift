//
// Created by Eliran Ben-Ezra on 2019-04-09.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import Foundation

struct Projectile {
    let position: Point
    let velocity: Vector
}

class ProjectileSimulation {
    let gravity: Vector
    let wind: Vector

    private(set) var projectile: Projectile
    private(set) var tickCount: Int = 0

    init(initialPosition: Point, initialVelocity: Point, wind: Vector, gravity: Vector) {
        self.gravity = gravity
        self.wind = wind
        self.projectile = Projectile(position: initialPosition, velocity: initialVelocity)
    }

    func tick() {
        tickCount += 1
        projectile = Projectile(
            position: projectile.position + projectile.velocity,
            velocity: projectile.velocity + gravity + wind
        )
    }
}
