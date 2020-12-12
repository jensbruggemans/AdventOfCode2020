import Foundation

public func day11() {
    let fileURL = Bundle.main.url(forResource: "day11", withExtension: "txt")
    let content: String = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8).trimmingCharacters(in: CharacterSet.newlines)
    let characters = content.components(separatedBy: "\n").map{ Array($0) }
    
    var seating1 = characters
    while case let nextSeating = seating1.nextSeating(), nextSeating != seating1 {
        seating1 = nextSeating
    }
    print("Day 11 part 1 result: \(seating1.amountOfOccupiedSeats)")
    
    var seating2 = characters
    while case let nextSeating = seating2.nextSeating2(), nextSeating != seating2 {
        seating2 = nextSeating
    }
    print("Day 11 part 2 result: \(seating2.amountOfOccupiedSeats)")
}

extension Array where Element == Array<Character> {
    
    var amountOfOccupiedSeats: Int {
        return self.reduce(0, { $0 + $1.reduce(0, { $0 + ($1 == "#" ? 1 : 0) }) })
    }
    
    func characterAt(row: Int, column: Int) -> Character {
        guard row >= 0, column >= 0, row < self.count, column < self[row].count else {
            return "."
        }
        return self[row][column]
    }
    
    func isOccupiedSeatAt(row: Int, column: Int) -> Bool {
        return characterAt(row: row, column: column) == "#"
    }
    
    func hasOccupiedSeatInDirection(r: Int, c: Int, fromRow:Int, fromColumn: Int) -> Bool {
        var row = fromRow + r
        var column = fromColumn + c
        while row >= 0 && column >= 0 && row < self.count && column < self[row].count {
            if isOccupiedSeatAt(row: row, column: column) {
                return true
            }
            else if hasSeatAt(row: row, column: column) {
                return false
            }
            row += r
            column += c
        }
        return false
    }
    
    func hasSeatAt(row: Int, column: Int) -> Bool {
        let character = characterAt(row: row, column: column)
        return character != "."
    }
    
    func numberOfOccupiedSeatsNextTo(row: Int, column: Int) -> Int {
        var sum = 0
        for r in -1...1 {
            for c in -1...1 {
                if r == 0 && c == 0 { continue }
                sum += isOccupiedSeatAt(row: row + r, column: column + c) ? 1 : 0
            }
        }
        return sum
    }
    
    func numberOfOccupiedSeatsVisibleFrom(row: Int, column: Int) -> Int {
        var sum = 0
        for r in -1...1 {
            for c in -1...1 {
                if r == 0 && c == 0 { continue }
                sum += hasOccupiedSeatInDirection(r: r, c: c, fromRow: row, fromColumn: column) ? 1 : 0
            }
        }
        return sum
    }
    
    func nextSeating() -> [[Character]] {
        var nextSeats = self
        for row in 0..<self.count {
            for column in 0..<self[row].count {
                guard hasSeatAt(row: row, column: column) else {
                    continue
                }
                let isOccupied = isOccupiedSeatAt(row: row, column: column)
                let numberOfAdjacentSeatsOccupied = numberOfOccupiedSeatsNextTo(row: row, column: column)
                if !isOccupied && numberOfAdjacentSeatsOccupied == 0 {
                    nextSeats[row][column] = "#"
                }
                else if isOccupied && numberOfAdjacentSeatsOccupied >= 4 {
                    nextSeats[row][column] = "L"
                }
            }
        }
        return nextSeats
    }
    
    func nextSeating2() -> [[Character]] {
        var nextSeats = self
        for row in 0..<self.count {
            for column in 0..<self[row].count {
                guard hasSeatAt(row: row, column: column) else {
                    continue
                }
                let isOccupied = isOccupiedSeatAt(row: row, column: column)
                let numberOfOccupiedSeatsVisible = numberOfOccupiedSeatsVisibleFrom(row: row, column: column)
                if !isOccupied && numberOfOccupiedSeatsVisible == 0 {
                    nextSeats[row][column] = "#"
                }
                else if isOccupied && numberOfOccupiedSeatsVisible >= 5 {
                    nextSeats[row][column] = "L"
                }
            }
        }
        return nextSeats
    }
}
