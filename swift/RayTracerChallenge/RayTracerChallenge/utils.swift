//
// Created by Eliran Ben-Ezra on 2019-04-21.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import Foundation

// Used to add equatable option to protocols without making them conform to Equatible that make it hard to work
//  with them
protocol DynamicEquatable {
    func isEqual(other: Any?) -> Bool
}

func == (lhs: DynamicEquatable, rhs: DynamicEquatable) -> Bool {
    return lhs.isEqual(other: rhs)
}

extension Double {
    static let EPSILON = 0.0001
}
