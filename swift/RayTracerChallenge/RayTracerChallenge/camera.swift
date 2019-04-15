//
// Created by Eliran Ben-Ezra on 2019-04-14.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import Foundation

class Camera {
    let hsize: Double
    let vsize: Double
    let fov: Double
    private(set) var transform: Matrix

    let halfWidth: Double
    let halfHeight: Double
    let pixelSize: Double

    init(hsize: Double, vsize: Double, fov: Double, transform: Matrix = Matrix.identity4x4) {
        self.hsize = hsize
        self.vsize = vsize
        self.fov = fov
        self.transform = transform

        let halfView = tan(fov/2)
        let aspect = hsize/vsize
        if aspect >= 1 {
            halfWidth = halfView
            halfHeight = halfView / aspect
        } else {
            halfWidth = halfView * aspect
            halfHeight = halfView
        }
        pixelSize = (halfWidth * 2) / hsize
    }

    @discardableResult
    func set(transform: Matrix) -> Camera {
        self.transform = transform
        return self
    }
}

extension Camera {
    func rayTo(x: Double, y: Double) -> Ray {
        let xOffset = (x + 0.5) * pixelSize
        let yOffset = (y + 0.5) * pixelSize

        let worldX = halfWidth - xOffset
        let worldY = halfHeight - yOffset

        let transformInverse = transform.inverse
        let pixel = transformInverse * point(x: worldX, y: worldY, z: -1)
        let origin = transformInverse * point(x: 0, y: 0, z: 0)
        let direction = (pixel - origin).normal

        return Ray(origin: origin, direction: direction)
    }
}

extension Camera {
    func render(world: World, progress: (Double) -> Void = { _ in }) -> Canvas {
        let c = Canvas(width: Int(hsize), height: Int(vsize))
        let totalPixels = c.width * c.height
        for y in 0..<c.height {
            for x in 0..<c.width {
                c[x, y] = world.color(for: rayTo(x: Double(x), y: Double(y)))
            }
            progress(Double((y+1)*c.width)/Double(totalPixels))
        }
        return c
    }
}
