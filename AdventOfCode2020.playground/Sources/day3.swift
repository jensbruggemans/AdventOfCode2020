import Foundation

public func day3() {
    let fileURL = Bundle.main.url(forResource: "day3", withExtension: "txt")
    let content: String = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
    let characterArrays = content.split(separator: "\n").map{Array($0)}
    let grid = Grid(arrays: characterArrays)
    print("Day 3 part 1 result: \(grid.numberOfTreesInDirection(right: 3, down: 1))")
    let product = [(1,1),(3,1),(5,1),(7,1),(1,2)].reduce(1, {$0 * grid.numberOfTreesInDirection(right: $1.0, down: $1.1)})
    print("Day 3 part 2 result: \(product)")
}

struct Grid {
    let arrays: [[Character]]
    func characterAt(row: Int, column: Int) -> Character {
        return arrays[row][column % arrays[row].count]
    }
    func hasTreeAt(row: Int, column: Int) -> Bool {
        return characterAt(row: row, column: column) == "#"
    }
    func numberOfTreesInDirection(right: Int, down: Int) -> Int {
        var row = 0
        var column = 0
        var count = 0
        while row < arrays.count {
            count += hasTreeAt(row: row, column: column) ? 1 : 0
            column += right
            row += down
        }
        return count
    }
}
