import Foundation

public func day2() {
    let fileURL = Bundle.main.url(forResource: "day2", withExtension: "txt")
    let content: String = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
    let inputStrings = content.split(separator: "\n")
    let passwordEntries = inputStrings.map({PasswordEntry(string: String($0))})
    let numberOfCorrectPasswords1 = passwordEntries.reduce(0, {$0 + ($1.isValid1() ? 1 : 0)})
    print("Day 2 part 1 result: \(numberOfCorrectPasswords1)")
    let numberOfCorrectPasswords2 = passwordEntries.reduce(0, {$0 + ($1.isValid2() ? 1 : 0)})
    print("Day 2 part 2 result: \(numberOfCorrectPasswords2)")
}

struct PasswordEntry {
    let min: Int
    let max: Int
    let character: Character
    let password: String
    init(string: String) {
        let components = string.components(separatedBy: CharacterSet(charactersIn: " -:")).compactMap({$0.isEmpty ? nil : $0})
        min = Int(components[0])!
        max = Int(components[1])!
        character = Character(components[2])
        password = components[3]
    }
    func isValid1() -> Bool {
        let amount = Array(password).amountOf(character)
        return min <= amount && amount <= max
    }
    func isValid2() -> Bool {
        let first = password.characterAt(min-1) == character
        let second = password.characterAt(max-1) == character
        return first != second
    }
}
