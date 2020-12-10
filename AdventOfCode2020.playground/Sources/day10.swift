import Foundation

public func day10() {
    let fileURL = Bundle.main.url(forResource: "day10", withExtension: "txt")
    let content: String = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8).trimmingCharacters(in: CharacterSet.newlines)
    let numbers = content.components(separatedBy: "\n").map{ Int($0)! }

    let sortedNumbers = ([0, 3 + numbers.max()!] + numbers).sorted()
    
    var amountOf1 = 0
    var amountOf3 = 0
    
    for i in 1..<sortedNumbers.count {
        let dif = sortedNumbers[i] - sortedNumbers[i - 1]
        if dif == 1 {
            amountOf1 += 1
        } else if dif == 3 {
            amountOf3 += 1
        }
    }
    
    print("Day 10 result 1: \(amountOf1 * amountOf3)")
    
    var dictionary: [Int: Int] = [:]
    
    func numberOfPathsTo(index: Int) -> Int {
        if let result = dictionary[index] {
            return result
        }
        if index == 0 { return 1 }
        if index < 0 { return 0 }
        var sum = 0
        for offset in 1...3 {
            let next = index - offset
            if next >= 0 && sortedNumbers[index] - sortedNumbers[next] <= 3 {
                sum += numberOfPathsTo(index: index - offset)
            }
        }
        dictionary[index] = sum
        return sum
    }
    
    print("Day 10 result 2: \(numberOfPathsTo(index: sortedNumbers.count - 1))")
}

