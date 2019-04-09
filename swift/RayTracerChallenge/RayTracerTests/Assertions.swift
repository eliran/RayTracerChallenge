//
// Created by Eliran Ben-Ezra on 2019-04-08.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import XCTest

extension XCTestCase {
    func expect<T>(_ value: T) -> AssertExpectation<T> {
        return AssertExpectation(value)
    }
}

class AssertExpectation<T> {
    private let value: T

    init(_ value: T) {
        self.value = value
    }


}

extension AssertExpectation where T: Equatable {
    func to(equal other: T) {
        XCTAssertEqual(value, other)
    }
}

extension AssertExpectation where T: FloatingPoint {
    func to(equal other: T, accuracy: T = T.leastNormalMagnitude) {
        XCTAssertEqual(value, other, accuracy: accuracy)
    }
}

extension AssertExpectation where T == Bool {
    func toBeTrue() {
        XCTAssertTrue(self.value)
    }

    func toBeFalse() {
        XCTAssertFalse(self.value)
    }
}
