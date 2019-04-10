//
// Created by Eliran Ben-Ezra on 2019-04-09.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import Foundation

class Canvas {
    let width: Int
    let height: Int

    private(set) var pixels: [Color]

    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.pixels = Array(repeating: color(r: 0, g: 0, b: 0), count: width * height)
    }

    subscript (x: Int, y: Int) -> Color {
        get {
            guard y >= 0, y < height, x >= 0, x < width else { return color(r: 0, g: 0, b: 0) }
            return pixels[y * width + x]
        }
        set(newValue) {
            guard y >= 0, y < height, x >= 0, x < width else { return }
            pixels[y * width + x] = newValue
        }
    }

    func clear(to color: Color) -> Self {
        pixels = Array(repeating: color, count: width * height)
        return self
    }
}

func canvas(width: Int, height: Int) -> Canvas {
    return Canvas(width: width, height: height)
}

extension Canvas {
    func toPPM() -> String {
        var output = [String]()
        output.append("P3")
        output.append("\(width) \(height)")
        output.append("255")

        var pixelOutput = ""

        func add(string: String) {
            if pixelOutput.isEmpty {
                pixelOutput += string
            } else {
                pixelOutput += " \(string)"
            }
        }

        func flush() {
            if !pixelOutput.isEmpty {
                output.append(pixelOutput)
                pixelOutput = ""
            }
        }

        func add(component: Double) {
            var componentOutput = "\(component.scale(to: 255))"
            let prependSpace = !pixelOutput.isEmpty
            let finalLength = pixelOutput.count + componentOutput.count + (prependSpace ? 1 : 0)

            if finalLength > 70 { flush() }
            add(string: componentOutput)
        }

        for y in 0..<height {
            for x in 0..<width {
                let color = self[x, y]
                add(component: color.r)
                add(component: color.g)
                add(component: color.b)
            }
            flush()
        }

        return output.joined(separator: "\n")
    }
}

extension Double {
    func scale(to max: Int) -> Int {
        return Int((self * Double(max)).rounded()).clamp(min: 0, max: max)
    }
}

extension Comparable {
    func clamp(min: Self, max: Self) -> Self {
        if self < min {
            return min
        }
        if self > max {
            return max
        }
        return self
    }
}
