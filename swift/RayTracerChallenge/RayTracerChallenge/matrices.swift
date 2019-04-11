//
// Created by Eliran Ben-Ezra on 2019-04-10.
// Copyright (c) 2019 Threeplay Inc. All rights reserved.
//

import Foundation

typealias Row4<T> = (T, T, T, T)
typealias Row3<T> = (T, T, T)
typealias Row2<T> = (T, T)
typealias Matrix4x4Type<T> = (Row4<T>, Row4<T>, Row4<T>, Row4<T>)
typealias Matrix3x3Type<T> = (Row3<T>, Row3<T>, Row3<T>)
typealias Matrix2x2Type<T> = (Row2<T>, Row2<T>)

struct Matrix {
    fileprivate var values: [Double]
    fileprivate let rows: Int
    fileprivate let cols: Int

    init(rows: Int, cols: Int, values: Double...) {
        assert(values.count == rows * cols)
        self.rows = rows
        self.cols = cols
        self.values = values
    }
}

extension Matrix {
    subscript(row: Int, col: Int) -> Double {
        get {
            return values[row*cols + col]
        }
        set(newValue) {
            values[row*cols + col] = newValue
        }
    }
}

extension Matrix: Equatable {
    public static func ==(lhs: Matrix, rhs: Matrix) -> Bool {
        return lhs.values == rhs.values
    }
}

struct Matrix4x4 {
    fileprivate var values: [Double]

    init(_ values: Matrix4x4Type<Double>) {
        self.values = Array(repeating: 0, count: 4*4)
        (self.values[ 0], self.values[ 1], self.values[ 2], self.values[ 3]) = values.0
        (self.values[ 4], self.values[ 5], self.values[ 6], self.values[ 7]) = values.1
        (self.values[ 8], self.values[ 9], self.values[10], self.values[11]) = values.2
        (self.values[12], self.values[13], self.values[14], self.values[15]) = values.3
    }
}

struct Matrix3x3 {
    fileprivate var values: [Double]

    init(_ values: Matrix3x3Type<Double>) {
        self.values = Array(repeating: 0, count: 3*3)
        (self.values[ 0], self.values[ 1], self.values[ 2]) = values.0
        (self.values[ 3], self.values[ 4], self.values[ 5]) = values.1
        (self.values[ 6], self.values[ 7], self.values[ 8]) = values.2
    }
}

struct Matrix2x2 {
    fileprivate var values: [Double]

    init(_ values: Matrix2x2Type<Double>) {
        self.values = Array(repeating: 0, count: 2*2)
        (self.values[ 0], self.values[ 1]) = values.0
        (self.values[ 2], self.values[ 3]) = values.1
    }
}

func matrix4x4(_ values: Matrix4x4Type<Double>) -> Matrix {
    return Matrix(
        rows: 4, cols: 4,
        values: values.0.0, values.0.1, values.0.2, values.0.3,
                values.1.0, values.1.1, values.1.2, values.1.3,
                values.2.0, values.2.1, values.2.2, values.2.3,
                values.3.0, values.3.1, values.3.2, values.3.3)
}

func matrix3x3(_ values: Matrix3x3Type<Double>) -> Matrix {
    return Matrix(
        rows: 3, cols: 3,
        values: values.0.0, values.0.1, values.0.2,
                values.1.0, values.1.1, values.1.2,
                values.2.0, values.2.1, values.2.2)
}

func matrix2x2(_ values: Matrix2x2Type<Double>) -> Matrix {
    return Matrix(
        rows: 2, cols: 2,
        values: values.0.0, values.0.1,
                values.1.0, values.1.1)
}
