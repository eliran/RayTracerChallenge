//
// Created by Eliran Ben-Ezra on 2019-04-08.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import XCTest

extension XCTestCase {
    func expect<T>(_ value: T, file: StaticString = #file, line: UInt = #line) -> AssertExpectation<T> {
        return AssertExpectation(value, file: file, line: line)
    }
}

class AssertExpectation<T> {
    private let value: T
    private let file: StaticString
    private let line: UInt

    init(_ value: T, file: StaticString, line: UInt) {
        self.value = value
        self.file = file
        self.line = line
    }


}

extension AssertExpectation where T: Equatable {
    func to(equal other: T) {
        XCTAssertEqual(value, other, file: file, line: line)
    }

    func to(notEqual other: T) {
        XCTAssertNotEqual(value, other, file: file, line: line)
    }

    static func == (lhs: AssertExpectation<T>, rhs: T) {
        lhs.to(equal: rhs)
    }

    static func != (lhs: AssertExpectation<T>, rhs: T) {
        lhs.to(notEqual: rhs)
    }
}

extension AssertExpectation where T: FloatingPoint {
    func to(equal other: T, accuracy: T = T.leastNormalMagnitude) {
        XCTAssertEqual(value, other, accuracy: accuracy, file: file, line: line)
    }

    func to(notEqual other: T, accuracy: T = T.leastNormalMagnitude) {
        XCTAssertNotEqual(value, other, accuracy: accuracy, file: file, line: line)
    }

    static func == (lhs: AssertExpectation<T>, rhs: T) {
        lhs.to(equal: rhs)
    }

    static func != (lhs: AssertExpectation<T>, rhs: T) {
        lhs.to(notEqual: rhs)
    }
}

extension AssertExpectation where T == Bool {
    func toBeTrue() {
        XCTAssertTrue(self.value, file: file, line: line)
    }

    func toBeFalse() {
        XCTAssertFalse(self.value, file: file, line: line)
    }
}
