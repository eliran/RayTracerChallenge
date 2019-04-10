//  Created by Eliran Ben-Ezra on 4/9/19.
//  Copyright © 2019 Threeplay Inc. All rights reserved.
//

import XCTest

class CanvasTest: XCTestCase {
   func test_create_a_canvas() {
      let c = canvas(width: 10, height: 20)

      expect(c.width) == 10
      expect(c.height) == 20
      expect(c.pixels.count) == 10 * 20
      expect(c.pixels.filter { $0 != color(r: 0, g: 0, b: 0) }.count) == 0
   }

   func test_writing_pixels_to_canvas() {
      let c = canvas(width: 10, height: 20)
      let red = color(r: 1, g: 0, b: 0)

      c[2, 3] = red

      expect(c[2, 3]) == red
   }

   func test_constructing_the_ppm_header() {
      let c = canvas(width: 5, height: 3)

      expect(c.toPPM().takeLines(3)) == """
                                        P3
                                        5 3
                                        255
                                        """
   }

   func test_constructing_the_ppm_pixel_data() {
      let c = canvas(width: 5, height: 3)
      let c1 = color(r: 1.5, g: 0, b: 0)
      let c2 = color(r: 0, g: 0.5, b: 0)
      let c3 = color(r: -0.5, g: 0, b: 1)

      c[0, 0] = c1
      c[2, 1] = c2
      c[4, 2] = c3

      expect(c.toPPM().skipLines(3)) == """
                                        255 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                        0 0 0 0 0 0 0 128 0 0 0 0 0 0 0
                                        0 0 0 0 0 0 0 0 0 0 0 0 0 0 255
                                        """
   }

   func test_splitting_long_lines_in_PPM_files() {
      let c = canvas(width: 10, height: 2).clear(to: color(r: 1, g: 0.8, b: 0.6))

      let lines = c.toPPM().skipLines(3).split(separator: "\n")

      expect(lines.count) == 4
      expect(lines[0]) == "255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204"
      expect(lines[1]) == "153 255 204 153 255 204 153 255 204 153 255 204 153"
      expect(lines[2]) == "255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204"
      expect(lines[3]) == "153 255 204 153 255 204 153 255 204 153 255 204 153"
   }

   func test_ppm_file_terminates_with_new_line() {
      let ppm = canvas(width: 5, height: 3).toPPM()

      expect(ppm.suffix(1)) == "\n"
   }
}

extension String {
   func skipLines(_ count: Int) -> String {
      return self.split(separator: "\n").dropFirst(count).joined(separator: "\n")
   }

   func takeLines(_ count: Int) -> String {
      return self.split(separator: "\n").prefix(count).joined(separator: "\n")
   }
}
