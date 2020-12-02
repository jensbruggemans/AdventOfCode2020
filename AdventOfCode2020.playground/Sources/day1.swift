import Foundation

public func day1() {
    let fileURL = Bundle.main.url(forResource: "day1", withExtension: "txt")
    let content: String = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
    let numbers = content.split(separator: "\n").compactMap({return Int($0)})
    let part1Results = findNumbers(array: numbers, amountOfNumbers: 2, addingUpTo: 2020)
    let part2Results = findNumbers(array: numbers, amountOfNumbers: 3, addingUpTo: 2020)
    for result in part1Results {
        let product: Int = result.reduce(1, {$0 * $1})
        print("Day 1 part 1 result: \(product) \(result)")
    }
    for result in part2Results {
        let product: Int = result.reduce(1, {$0 * $1})
        print("Day 1 part 2 result: \(product) \(result)")
    }
}

func findNumbers(array: [Int], amountOfNumbers: Int, addingUpTo target: Int) -> [[Int]] {
    if amountOfNumbers <= 1 {
        return array.filter({$0 == target}).map({return [$0]})
    } else {
        var mutableArray = array
        var results = [[Int]]()
        while mutableArray.count > 0 {
            let number = mutableArray.removeFirst()
            let result = findNumbers(array: mutableArray, amountOfNumbers: amountOfNumbers - 1, addingUpTo: target - number)
            if !result.isEmpty {
                let mappedResult = result.map({return [number] + $0})
                results = results + mappedResult
            }
        }
        return results
    }
}
