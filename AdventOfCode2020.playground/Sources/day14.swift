import Foundation

public func day14() {
    let fileURL = Bundle.main.url(forResource: "day14", withExtension: "txt")
    let content: String = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8).trimmingCharacters(in: CharacterSet.newlines)
    let lines = content.components(separatedBy: "\n")
    let maskRegex = "mask = (\\w*)"
    let memRegex = "mem\\[(\\d*)\\] = (\\d*)"
    let instructions: [Instruction] = lines.compactMap{
        let maskMatches = $0.firstRegexMatch(maskRegex)
        if maskMatches.count == 2 {
            return .mask(mask: Array(maskMatches[1]))
        }
        let memMatches = $0.firstRegexMatch(memRegex)
        if memMatches.count == 3 {
            return .mem(location: Int(memMatches[1])!, value: Int(memMatches[2])!)
        }
        return nil
    }
    print("Day 14 part 1 result: \(part1(instructions: instructions))")
    print("Day 14 part 2 result: \(part2(instructions: instructions))")
}

private func part1(instructions: [Instruction]) -> Int {
    var dictionary = [Int: Int]()
    var mask: [Character] = []
    for instruction in instructions {
        switch instruction {
        case .mask(let newMask):
            mask = newMask
        case .mem(let location, let value):
            dictionary[location] = Int(value, mask: mask)
        }
    }
    return dictionary.values.reduce(0, {$0+$1})
}

private func part2(instructions: [Instruction]) -> Int {
    var dictionary = [Int: Int]()
    var mask: [Character] = []
    for instruction in instructions {
        switch instruction {
        case .mask(let newMask):
            mask = newMask
        case .mem(let location, let value):
            for address in allAddressesFrom(address: location, mask: mask) {
                dictionary[address] = value
            }
        }
    }
    return dictionary.values.reduce(0, {$0+$1})
}

private func allAddressesFrom(address: Int, mask: [Character]) -> [Int] {
    let reversedMask = Array(mask.reversed())
    let reversedBinary = Array(Array(String(address, radix: 2)).reversed())
    var newReversed = [Character]()
    for (index, maskCharacter) in reversedMask.enumerated() {
        if maskCharacter == "0" {
            newReversed.append(reversedBinary.count > index ? reversedBinary[index] : "0")
        } else if maskCharacter == "1" {
            newReversed.append("1")
        } else {
            newReversed.append("0")
        }
    }
    let number = Int(String(newReversed.reversed()), radix: 2)!
    return allPossibleAdditions(mask: mask).map{ $0 + number }
}

private func allPossibleAdditions(mask: [Character]) -> [Int] {
    guard let firstX = mask.firstIndex(of: "X") else {
        return [0]
    }
    let allFurtherOptions = allPossibleAdditions(mask: Array(mask[firstX+1..<mask.count]))
    return allFurtherOptions.map{$0 + Int(pow(2, Double(mask.count - 1 - firstX)))} + allFurtherOptions
}

private enum Instruction {
    case mask(mask: [Character])
    case mem(location: Int, value: Int)
}

extension Int {
    public init(_ input: Int, mask: [Character]) {
        let inputBinary = Array(String(input, radix: 2))
        var newArray = [Character]()
        for (index, maskChar) in mask.reversed().enumerated() {
            let inputChar: Character
            if inputBinary.count > index {
                inputChar = inputBinary[inputBinary.count - 1 - index]
            } else {
                inputChar = "0"
            }
            newArray.append(maskChar == "X" ? inputChar : maskChar)
        }
        self = Int(String(newArray.reversed()), radix: 2)!
    }
}
