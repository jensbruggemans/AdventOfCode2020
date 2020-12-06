import Foundation

public func day6() {
    let fileURL = Bundle.main.url(forResource: "day6", withExtension: "txt")
    let content: String = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8).trimmingCharacters(in: CharacterSet.newlines)
    let groups = content.components(separatedBy: "\n\n")
    let alphaSet = Set("abcdefghijklmnopqrstuvwxyz")
    
    let groupCounts = groups.map{Set($0.filter{alphaSet.contains($0)}).count}
    let sum = groupCounts.reduce(0, {$0 + $1})
    print("Day 6 part 1 result: \(sum)")
    
    let groupedChoices: [[Set<Character>]] = groups.map{$0.components(separatedBy: "\n").map{Set($0)}}
    let universalChoices = groupedChoices.map{$0.reduce(alphaSet, {$0.intersection($1)})}
    let sum2 = universalChoices.reduce(0, {$0 + $1.count})
    print("Day 6 part 2 result: \(sum2)")
}
