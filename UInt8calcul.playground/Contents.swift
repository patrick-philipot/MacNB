import Cocoa

var u1: UInt8
var u2: UInt8
var addResult :(partialValue: UInt8, overflow: Bool)

print("Addition, substraction with UInt8")

// addition within limits
u1 = 100
u2 = 50
addResult = u1.addingReportingOverflow(u2)
u1 = addResult.overflow ? 255 : addResult.partialValue
print("Expected 150 ", u1)

// addition outside limits
u1 = 150
u2 = 150
addResult = u1.addingReportingOverflow(u2)
u1 = addResult.overflow ? 255 : addResult.partialValue
print("Expected 255 ", u1)

// substraction within limits
u1 = 101
u2 = 99
addResult = u1.subtractingReportingOverflow(u2)
u1 = addResult.overflow ? 0 : addResult.partialValue
print("Expected 2 ", u1)

// substraction within limits
u1 = 10
u2 = 99
addResult = u1.subtractingReportingOverflow(u2)
u1 = addResult.overflow ? 0 : addResult.partialValue
print("Expected 0 ", u1)

print("Limit checking")
struct Matrix {
  let row: Int
  let column: Int
}

let AtkinsonMatrix = [
  Matrix(row: 0, column: 1),
  Matrix(row: 0, column: 2),
  Matrix(row: 1, column: -1),
  Matrix(row: 1, column: 0),
  Matrix(row: 1, column: 1),
  Matrix(row: 2, column: 0)
]

let height = 4
let width  = 6


for y in 0..<height {
    for x in 0..<width {

        print("(\(x),\(y)) -> ", terminator: " ")
        
        for neighbor in AtkinsonMatrix {
          let row = y + neighbor.row
          let column = x + neighbor.column
            guard row >= 0 && row < height && column >= 0 && column < width else {continue}
            print("(\(column), \(row))", terminator: ", ")
        }
       print("")
//
    }
}
print("Test terminated.")
