import Foundation

public func day9() {
    let fileURL = Bundle.main.url(forResource: "day9", withExtension: "txt")
    let content: String = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8).trimmingCharacters(in: CharacterSet.newlines)
    let numbers = content.components(separatedBy: "\n").map{ Int($0)! }
    
    let result1 = numbers[25..<numbers.count].enumerated().first(where: {
        !Array(numbers[$0..<25 + $0]).canAddTo($1)
    })!.1
    print("Day 9 part 1 result: \(result1)")
   
    let array = numbers.subArrayAddingUpTo(result1)!
    let result2 = array.min()! + array.max()!
    print("Day 9 part 2 result: \(result2)")
}

extension Array where Element == Int {
    func canAddTo(_ sum: Int) -> Bool {
        return self.enumerated().first(where: { self[($0 + 1)..<self.count].contains(sum - $1) }) != nil
    }
    
    func subArrayAddingUpTo(_ sum: Int) -> [Int]? {
        var startIndex = 0
        var endIndex = 0
        var subSum = self[startIndex]
        while startIndex <= endIndex && endIndex < self.count {
            if subSum > sum {
                subSum -= self[startIndex]
                startIndex += 1
            } else if subSum < sum {
                endIndex += 1
                subSum += self[endIndex]
            } else {
                return Array(self[startIndex..<endIndex])
            }
        }
        return nil
    }
}
