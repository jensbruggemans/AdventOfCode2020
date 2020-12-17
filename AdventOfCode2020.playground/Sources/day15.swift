import Foundation

public func day15() {
    let fileURL = Bundle.main.url(forResource: "day15", withExtension: "txt")
    let content: String = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8).trimmingCharacters(in: CharacterSet.newlines)
    let numbers = content.components(separatedBy: ",").map{ Int($0)! }
    
    
    let part1Numbers = numbers
    var part1Dictionary1 = [Int:Int]()
    var part1Dictionary2 = [Int:Int]()
    for (index,number) in numbers.enumerated() {
        part1Dictionary1[number] = index
    }
    
    var lastNumber = part1Numbers.last!
    var numbersSpoken = part1Numbers.count
    
    while numbersSpoken < 30000000 {
        if let oldIndex = part1Dictionary2[lastNumber] {
            let newNumber = numbersSpoken - oldIndex - 1
            part1Dictionary2[newNumber] = part1Dictionary1[newNumber]
            part1Dictionary1[newNumber] = numbersSpoken
            lastNumber = newNumber
        }
        else {
            let newNumber = 0
            part1Dictionary2[newNumber] = part1Dictionary1[newNumber]
            part1Dictionary1[newNumber] = numbersSpoken
            lastNumber = newNumber
        }
        numbersSpoken += 1
        if numbersSpoken == 2020 {
            print("Day 15 part 1 result: \(lastNumber)")
        }
        if numbersSpoken == 30000000 {
            print("Day 15 part 2 result: \(lastNumber)")
        }
    }
}
