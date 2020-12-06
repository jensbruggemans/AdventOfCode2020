import Foundation

public func day5() {
    let fileURL = Bundle.main.url(forResource: "day5", withExtension: "txt")
    let content: String = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
    let characterArrays = content.split(separator: "\n").map{Array($0)}
    
    let seatIds = Set(characterArrays.map{ $0.toInt(oneCharacters: Set("BR"))})
    let highestId = seatIds.reduce(0, { $0 > $1 ? $0 : $1})
    print("Day 5 part 1 result: \(highestId)")
    
    let yourId = seatIds.first(where: { !seatIds.contains($0 + 1) && seatIds.contains($0 + 2) })! + 1
    print("Day 5 part 2 result: \(yourId)")
}

extension Array where Element == Character {
    func toInt(oneCharacters: Set<Character>) -> Int {
        return self.enumerated().reduce(0,
            { $0 + (oneCharacters.contains($1.element) ? Int(pow(2, Double(self.count - $1.offset - 1))) : 0) })
    }
}
