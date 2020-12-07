import Foundation

public func day7() {
    let fileURL = Bundle.main.url(forResource: "day7", withExtension: "txt")
    let content: String = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8).trimmingCharacters(in: CharacterSet.newlines)
    let lines = content.components(separatedBy: "\n")
    
    let matches = lines.map{ $0.allRegexMatches("(?:^|(\\d) )((?:[a-z]+ [a-z]+)+) bags?") }
    let allBagTypes = Set(matches.map{$0[0][1]})
    var allBags: [String:Bag] = [:]
    for bagType in allBagTypes {
        allBags[bagType] = Bag(name: bagType)
    }
    for match in matches {
        let containerBagType = match[0][1]
        let containerBag = allBags[containerBagType]!
        for i in 1..<match.count {
            let insideBag = allBags[match[i][2]]!
            let amount = Int(match[i][1])!
            containerBag.containedBags[insideBag] = amount
        }
    }
    
    let shinyGoldBag = allBags["shiny gold"]!
    print("Day 7 part 1 result: \(allBags.values.filter{ $0.contains(bag: shinyGoldBag) }.count)")
    print("Day 7 part 2 result: \(shinyGoldBag.amountContained())")
}

class Bag: Hashable {
    static func == (lhs: Bag, rhs: Bag) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    let name: String
    var containedBags: [Bag: Int] = [:]
    init(name: String) {
        self.name = name
    }
    
    func contains(bag: Bag) -> Bool {
        if containedBags.keys.contains(bag) {
            return true
        }
        for containedBag in containedBags.keys {
            if containedBag.contains(bag: bag) {
                return true
            }
        }
        return false
    }
    
    func amountContained() -> Int {
        var total = 0
        for (bag, amount) in containedBags {
            total += amount * (1 + bag.amountContained())
        }
        return total
    }
}
