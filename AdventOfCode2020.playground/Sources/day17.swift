import Foundation

public func day17() {
    let fileURL = Bundle.main.url(forResource: "day17", withExtension: "txt")
    let content: String = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8).trimmingCharacters(in: CharacterSet.newlines)
    let lines = content.components(separatedBy: "\n")
    
    var initialGrid = Set<Int>()
    for (y, line) in lines.enumerated() {
        for (x, character) in line.enumerated() {
            if character == "#" {
                let position = Int(x: x, y: y)
                initialGrid.insert(position)
            }
        }
    }
    var grid = initialGrid
    for _ in 1...6 {
        grid = grid.nextGrid(numberOfDimensions: 3)
    }
    print("Day 17 part 1 result: \(grid.count)")
    grid = initialGrid
    for _ in 1...6 {
        grid = grid.nextGrid(numberOfDimensions: 4)
    }
    print("Day 17 part 2 result: \(grid.count)")
}

extension Set where Element == Int {
    func nextGrid(numberOfDimensions: Int) -> Self {
        let allPositionsToCheck = self.reduce(self, { $0.union($1.adjacentPositions(numberOfDimensions: numberOfDimensions)) })
        var newGrid = Self()
        for position in allPositionsToCheck {
            let numberOfAdjacents = numberOfAdjacentCubes(position: position, numberOfDimensions: numberOfDimensions)
            let hasCube = self.contains(position)
            if hasCube && (numberOfAdjacents == 2 || numberOfAdjacents == 3) {
                newGrid.insert(position)
            } else if !hasCube && numberOfAdjacents == 3 {
                newGrid.insert(position)
            }
        }
        return newGrid
    }
    
    func numberOfAdjacentCubes(position: Int, numberOfDimensions: Int) -> Int {
        let adjacentPositions = position.adjacentPositions(numberOfDimensions: numberOfDimensions)
        return adjacentPositions.reduce(0, { $0 + (self.contains($1) ? 1 : 0) })
    }
}

let rangePerDimension = 1000

extension Int {
    var z: Int {
        return positionAtDimension(0)
    }
    var y: Int {
        return positionAtDimension(1)
    }
    var x: Int {
        return positionAtDimension(2)
    }
    var w: Int {
        return positionAtDimension(3)
    }
    
    public init(x: Int, y: Int, z: Int = 0, w: Int = 0) {
        let zPart = z + rangePerDimension / 2
        let yPart = (y + rangePerDimension / 2) * rangePerDimension
        let xPart = (x + rangePerDimension / 2) * rangePerDimension * rangePerDimension
        let wPart = (w + rangePerDimension / 2) * rangePerDimension * rangePerDimension * rangePerDimension
        self = zPart + yPart + xPart + wPart
    }
    
    static var calculatedAdjacentOffSetsPerDimension = [Int: [Int]]()
    static func adjacentOffsetsForDimensions(numberOfDimensions: Int) -> [Int] {
        if let offsets = calculatedAdjacentOffSetsPerDimension[numberOfDimensions] {
            return offsets
        }
        var adjacentOffsets = [0]
        var multiplier = 1
        for _ in 0..<numberOfDimensions {
            adjacentOffsets = adjacentOffsets.reduce([Int](), { $0 + [$1, $1 - multiplier, $1 + multiplier] })
            multiplier *= rangePerDimension
        }
        adjacentOffsets = adjacentOffsets.filter{ $0 != 0 }
        calculatedAdjacentOffSetsPerDimension[numberOfDimensions] = adjacentOffsets
        return adjacentOffsets
    }
    
    func adjacentPositions(numberOfDimensions: Int) -> [Int] {
        return Self.adjacentOffsetsForDimensions(numberOfDimensions: numberOfDimensions).map {$0 + self}
    }
    
    func positionAtDimension(_ dimensionNumber: Int) -> Int {
        let rangePowed = Int(pow(Double(rangePerDimension), Double(dimensionNumber)))
        return (self / rangePowed) % rangePerDimension - rangePerDimension / 2
    }
}
