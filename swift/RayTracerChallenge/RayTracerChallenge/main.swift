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
        let start = Date()
        try? invoke()?.toPPM().write(toFile: path, atomically: true, encoding: .utf8)
        let duration = -start.timeIntervalSinceNow
        print("Rendering took: \(duration)s")
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

        let i = Matrix.identity4x4
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

        let s = Shapes.sphere().set(transform: Matrix.shearing(xy: 1, xz: 0, yx: 0, yz: 0, zx: 0, zy: 0) * Matrix.scaling(x: 0.5, y: 1, z: 1))

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

                if r.intersects(s).hit != nil {
                    set(canvas: c, point(x: Double(x), y: Double(y), z: 0), color: color(r: 1, g: 0, b: 1))
                }
            }
        }

        return c
    }
}

class RayCastRenderer {
    private var objects: [Sphere] = []
    private var lights: [PointLight] = []
    private let canvas: Canvas

    init(width: Int, height: Int) {
        self.canvas = Canvas(width: width, height: height)
    }

    func add(object: Sphere) {
        self.objects.append(object)
    }

    func add(light: PointLight) {
        self.lights.append(light)
    }


    func render(origin: Point = Tuple(x: 0, y: 0, z: -5, w: 1)) -> Canvas {
        let wall_z = 10.0
        let wall_size = 7.0
        let pixel_size = wall_size / Double(min(canvas.width, canvas.height))
        let half = wall_size / 2

        for y in 0..<canvas.width {
            let world_y = half - pixel_size * Double(y)
            for x in 0..<canvas.height {
                let world_x = -half + pixel_size * Double(x)
                let wall_position = point(x: world_x, y: world_y, z: wall_z)

                let r = ray(origin: origin, direction: (wall_position - origin).normal)

                if let h = hit(objects.reduce([]) { $0 + r.intersects($1) }) {
                    let hitPoint = r.position(h.t)
                    let hitNormal = h.object.normal(at: hitPoint)
                    let eye = -r.direction

                    let finalColor = lights.reduce(color(r: 0, g: 0, b: 0)) {
                        $0 + h.object.material.lighting(light: $1, position: hitPoint, eye: eye, normal: hitNormal)
                    }
                    set(canvas: canvas, point(x: Double(x), y: Double(y), z: 0), color: finalColor)
                }
            }
        }

        return canvas
    }
}

class Chapter6Demo: Demo {
    static let name = "Ray cast a sphere with lighting"

    static func invoke() -> Canvas? {

        let s = Shapes.sphere()
            //.set(transform: Matrix.shearing(xy: 1, xz: 0, yx: 0, yz: 0, zx: 0, zy: 0) * Matrix.scaling(x: 0.5, y: 1, z: 1))
            .set(material: Material.make(color: color(r: 1, g: 0.2, b: 1)))

        let light = Light.point(position: point(x: 10, y: 10, z: -10), intensity: color(r: 1, g: 1, b: 1))

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

                if let h = r.intersects(s).hit {
                    let hitPoint = r.position(h.t)
                    let hitNormal = h.object.normal(at: hitPoint)
                    let eye = -r.direction

                    let color = h.object.material.lighting(light: light, position: hitPoint, eye: eye, normal: hitNormal)
                    set(canvas: c, point(x: Double(x), y: Double(y), z: 0), color: color)
                }
            }
        }

        return c
    }
}

class RayCasterDemo: Demo {
    static let name = "Ray caster"

    static func invoke() -> Canvas? {
        let caster = RayCastRenderer(width: 200, height: 200)
        caster.add(light: Light.point(position: point(x: 10, y: 10, z: -10), intensity: color(r: 1, g: 1, b: 1)))
        caster.add(light: Light.point(position: point(x: 10, y: -10, z: -10), intensity: color(r: 0, g: 1, b: 0)))

        caster.add(object: Shapes.sphere().set(material: Material.make(color: color(r: 1, g: 0.2, b: 1))))
        caster.add(object: Shapes.sphere().set(material: Material.make(color: color(r: 0, g: 0.2, b: 1)))
            .set(transform: .translation(x: 0.2, y: -0.2, z: 0)))

        return caster.render()
    }
}

class Ch7Scene: Demo {
    static let name = "Ch 7. Scene"

    static func invoke() -> Canvas? {
        let w = World()
        let c = Camera(hsize: 400, vsize: 200, fov: .pi/3)
            .set(transform: .view(from: point(x: 0, y: 1.5, z: -5), to: point(x: 0, y: 1, z: 0), up: vector(x: 0, y: 1, z: 0)))

        let floor = Shapes.sphere().set(material: .make(color: Color.stripe(color(r: 1, g: 0, b: 0), color(r: 0, g: 1, b: 0)), specular: 0)).set(transform: .scaling(x: 10, y: 0.01, z: 10))
        let leftWall = Shapes.sphere().set(material: floor.material)
            .set(transform: Matrix.scaling(x: 10, y: 0.01, z: 10).rotate(x: .pi/2).rotate(y: .pi / -4).translate(x: 0, y: 0, z: 5))
        let rightWall = Shapes.sphere().set(material: floor.material)
            .set(transform: Matrix.scaling(x: 10, y: 0.01, z: 10).rotate(x: .pi/2).rotate(y: .pi/4).translate(x: 0, y: 0, z: 5))

        let middle = Shapes.sphere().set(material: .make(color: color(r: 0.1, g: 1, b: 0.5), diffuse: 0.7, specular: 0.3))
            .set(transform: .translation(x: -0.5, y: 1, z: 0.5))

        let right = Shapes.sphere().set(material: .make(color: color(r: 0.5, g: 1, b: 0.1), diffuse: 0.7, specular: 0.3))
            .set(transform: Matrix.scaling(x: 0.5, y: 0.5, z: 0.5).translate(x: 1.5, y: 0.5, z: -0.5))

        let left = Shapes.sphere().set(material: .make(color: color(r: 1, g: 0.8, b: 0.1), diffuse: 0.7, specular: 0.3))
            .set(transform: Matrix.scaling(x: 0.33, y: 0.33, z: 0.33).translate(x: -1.5, y: 0.33, z: -0.75))

        w.add(objects: floor, leftWall, rightWall, left, right, middle)
            .add(light: Light.point(position: point(x: -10, y: 10, z: -10), intensity: color(r: 1, g: 1, b: 1)))

//            .add(light: Light.point(position: point(x: 10, y: 10, z: -10), intensity: color(r: 1, g: 0, b: 0)))

        let start = Date()
        func toTime(_ seconds: Double) -> String {
            guard seconds >= 0 else { return "---" }
            return String(format: "%02d:%02d", arguments: [Int(seconds)/60, Int(seconds)%60])
        }

        return c.render(world: w) {
            let elapsed = -start.timeIntervalSinceNow
            let estimated = $0 > 0 ? (elapsed / $0) : -1
            print("[\(Int($0*100))%] \(toTime(elapsed)) ETA: \(toTime(estimated))     ", terminator: "\n")
            fflush(__stdoutp)
        }
    }
}

class Ch9Scene: Demo {
  static let name = "Ch 9. Plane"

  static func invoke() -> Canvas? {
    let w = World()
    let scale = 4.0
    let p1 = Color.stripe(color(r: 1, g: 0, b: 0), color(r: 0, g: 1, b: 0)).set(transform: .scaling(x: 0.2, y: 0.2, z: 0.2))
    let p2 = Color.stripe(color(r: 0.1, g: 1, b: 0.5), color(r: 1, g: 0.5, b: 0.1)).set(transform: .rotation(y: .pi/4))
    let c = Camera(hsize: 400*scale, vsize: 200*scale, fov: .pi/3)
      .set(transform: .view(from: point(x: 0, y: 1.5, z: -5), to: point(x: 0, y: 1, z: 0), up: vector(x: 0, y: 1, z: 0)))

    let floor = Shapes.plane().set(material: .make(color: p1, specular: 0)).set(transform: .scaling(x: 10, y: 0.01, z: 10))
//    let leftWall = Shapes.sphere().set(material: floor.material)
//      .set(transform: Matrix.scaling(x: 10, y: 0.01, z: 10).rotate(x: .pi/2).rotate(y: .pi / -4).translate(x: 0, y: 0, z: 5))
//    let rightWall = Shapes.sphere().set(material: floor.material)
//      .set(transform: Matrix.scaling(x: 10, y: 0.01, z: 10).rotate(x: .pi/2).rotate(y: .pi/4).translate(x: 0, y: 0, z: 5))

    let middle = Shapes.sphere().set(material: .make(color: p2, diffuse: 0.7, specular: 0.3))
      .set(transform: .translation(x: -0.5, y: 1, z: 0.5))

    let right = Shapes.sphere().set(material: .make(color: color(r: 0.5, g: 1, b: 0.1), diffuse: 0.7, specular: 0.3))
      .set(transform: Matrix.scaling(x: 0.5, y: 0.5, z: 0.5).translate(x: 1.5, y: 0.5, z: -0.5))

    let left = Shapes.sphere().set(material: .make(color: color(r: 1, g: 0.8, b: 0.1), diffuse: 0.7, specular: 0.3))
      .set(transform: Matrix.scaling(x: 0.33, y: 0.33, z: 0.33).translate(x: -1.5, y: 0.33, z: -0.75))

    w.add(objects: floor, left, right, middle)
      .add(light: Light.point(position: point(x: -10, y: 10, z: -10), intensity: color(r: 1, g: 1, b: 1)))

    //            .add(light: Light.point(position: point(x: 10, y: 10, z: -10), intensity: color(r: 1, g: 0, b: 0)))

    let start = Date()
    func toTime(_ seconds: Double) -> String {
      guard seconds >= 0 else { return "---" }
      return String(format: "%02d:%02d", arguments: [Int(seconds)/60, Int(seconds)%60])
    }

    return c.render(world: w) {
      let elapsed = -start.timeIntervalSinceNow
      let estimated = $0 > 0 ? (elapsed / $0) : -1
      print("[\(Int($0*100))%] \(toTime(elapsed)) ETA: \(toTime(estimated))     ", terminator: "\n")
      fflush(__stdoutp)
    }
  }
}

//MatricesDemo.run(basePath: basePath)
//Chapter4Clock.run(basePath: basePath)
//ProjectileDemo.run(basePath: basePath)
//RayCasterDemo.run(basePath: basePath)
//Ch7Scene.run(basePath: basePath)
Ch9Scene.run(basePath: basePath)

