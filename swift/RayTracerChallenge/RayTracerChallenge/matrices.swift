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
        self.init(rows: rows, cols: cols, values: values)
    }

    init(rows: Int, cols: Int, values: [Double]) {
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

extension Matrix {
    static func * (lhs: Matrix, rhs: Matrix) -> Matrix {
        // Same square matrix
        assert(lhs.rows == rhs.rows && lhs.cols == rhs.cols && lhs.cols == lhs.rows)
        let dim = lhs.rows
        var values = Array<Double>(repeating: 0, count: dim * dim)
        for row in 0..<dim {
            let rowBase = row * dim
            for col in 0..<dim {
                var sum: Double = 0
                for i in 0..<dim {
                    sum += lhs[row, i] * rhs[i, col]
                }
                values[rowBase + col] = sum
            }
        }
        return Matrix(rows: lhs.rows, cols: rhs.cols, values: values)
    }
}

extension Matrix {
    static func * (lhs: Matrix, rhs: Tuple) -> Tuple {
        assert(lhs.cols == 4 && lhs.rows == 4)
        var values = Array<Double>(repeating: 0, count: 4)
        for row in 0..<lhs.rows {
            values[row] = lhs[row, 0] * rhs.x + lhs[row, 1] * rhs.y + lhs[row, 2] * rhs.z + lhs[row, 3] * rhs.w
        }
        return tuple(x: values[0], y: values[1], z: values[2], w: values[3])
    }
}

extension Matrix: Equatable {
    public static func ==(lhs: Matrix, rhs: Matrix) -> Bool {
        return lhs.values == rhs.values
    }

    func approximate(digits: Int) -> Matrix {
        let multiplier = Double.approximateMultiplier(digits: digits)
        return Matrix(rows: self.rows, cols: self.cols, values: self.values.map {
            $0.approximate(multiplier: multiplier)
        })
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

extension Matrix {
    static let identity4x4 = Matrix(rows: 4, cols: 4, values: 1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1)

    var transposed: Matrix {
        var transposedValues = Array<Double>(repeating: 0, count: self.values.count)
        for row in 0..<self.rows {
            for col in 0..<self.cols {
                transposedValues[col*self.rows + row] = self.values[row*self.cols + col]
            }
        }
        return Matrix(rows: self.cols, cols: self.rows, values: transposedValues)
    }
}

extension Matrix {
    var determinant: Double {
        assert(self.rows == self.cols && self.rows >= 2)
        // 2x2 matrix
        if self.rows == 2 {
            return values[0] * values[3] - values[1] * values[2]
        }
        var det = 0.0
        for c in 0..<self.cols {
            det += self.values[c] * self.cofactor(0, c)
        }
        return det
    }

    func submatrix(_ row: Int, _ col: Int) -> Matrix {
        var values = Array<Double>(repeating: 0, count: (self.rows-1)*(self.cols-1))
        var i = 0
        for r in 0..<self.rows where r != row {
            for c in 0..<self.cols where c != col {
                values[i] = self.values[r*self.cols + c]
                i += 1
            }
        }
        return Matrix(rows: self.rows-1, cols: self.cols-1, values: values)
    }

    func minor(_ row: Int, _ col: Int) -> Double {
        return submatrix(row, col).determinant
    }

    func cofactor(_ row: Int, _ col: Int) -> Double {
        let invert = (row+col) & 1 == 1 ? -1.0 : 1.0
        return invert * minor(row, col)
    }

    var isInvertible: Bool {
        return determinant != 0
    }

    var inverse: Matrix {
        let det = determinant
        assert(det != 0)
        var values = Array<Double>(repeating: 0, count: self.values.count)
        for row in 0..<self.rows {
            for col in 0..<self.cols {
                values[row*self.cols + col] = cofactor(col, row) / det
            }
        }
        return Matrix(rows: self.rows, cols: self.cols, values: values)
    }
}
