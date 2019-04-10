//  Created by Eliran Ben-Ezra on 4/9/19.
//  Copyright © 2019 Threeplay Inc. All rights reserved.
//

import XCTest

class ColorsTest: XCTestCase {
    func test_colors_are_red_green_blue_tuples() {
        let c = color(r: -0.5, g: 0.4, b: 1.7)

        expect(c.r) == -0.5
        expect(c.g) == 0.4
        expect(c.b) == 1.7
    }

    func test_adding_colors() {
        let c1 = color(r: 0.9, g: 0.6, b: 0.75)
        let c2 = color(r: 0.7, g: 0.1, b: 0.25)

        expect(c1 + c2) == color(r: 1.6, g: 0.7, b: 1.0)
    }

    func test_subtracting_colors() {
        let c1 = color(r: 0.9, g: 0.6, b: 0.75)
        let c2 = color(r: 0.7, g: 0.1, b: 0.25)

        expect(c1 - c2) == color(r: 0.2, g: 0.5, b: 0.5)
    }

    func test_multiplying_a_color_by_a_scalar() {
        let c = color(r: 0.2, g: 0.3, b: 0.4)

        expect(c * 2) == color(r: 0.4, g: 0.6, b: 0.8)
    }

    func test_multiplying_colors() {
        let c1 = color(r: 1, g: 0.2, b: 0.4)
        let c2 = color(r: 0.9, g: 1, b: 0.1)

        expect(c1 * c2) == color(r: 0.9, g: 0.2, b: 0.04)
    }
}
