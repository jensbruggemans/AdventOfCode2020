import Foundation

public func day16() {
    let fileURL = Bundle.main.url(forResource: "day16", withExtension: "txt")
    let content: String = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8).trimmingCharacters(in: CharacterSet.newlines)
    let lines = content.components(separatedBy: "\n")
    
    var rules = [Rule]()
    var tickets = [[Int]]()
    lines.forEach {
        line in
        let ruleComponents = line.firstRegexMatch("^(.*): (\\d+)-(\\d+) or (\\d+)-(\\d+)$")
        let numberComponents = line.components(separatedBy: ",")
        if ruleComponents.count == 6 {
            let rule = Rule(name: ruleComponents[1],
                            firstRangeMin: Int(ruleComponents[2])!,
                            firstRangeMax: Int(ruleComponents[3])!,
                            secondRangeMin: Int(ruleComponents[4])!,
                            secondRangeMax: Int(ruleComponents[5])!)
            rules.append(rule)
        }
        else if numberComponents.count == rules.count {
            tickets.append(numberComponents.map{ Int($0)! })
        }
        
    }
    print("Day 16 part 1 result: \(calculateTicketScanningErrorRate(tickets: tickets, rules: rules))")
    
    var rulesToIndexes = [Rule: [Int]]()
    for rule in rules {
        rulesToIndexes[rule] = [Int](0..<rules.count)
    }
    
    let validTickets = tickets.filter {
        for number in $0 {
            var numberIsValid = false
            for rule in rules {
                if rule.isValid(number) {
                    numberIsValid = true
                    continue
                }
            }
            if !numberIsValid {
                return false
            }
        }
        return true
    }
    
    for ticket in validTickets {
        for rule in rules {
            let indexesToCheck = rulesToIndexes[rule]!
            var indexesToKeep = [Int]()
            for index in indexesToCheck {
                if rule.isValid(ticket[index]) {
                    indexesToKeep.append(index)
                }
            }
            rulesToIndexes[rule] = indexesToKeep
        }
    }
    
    let rulesWithValidPositions = rules.map{ return RuleWithValidPositions(rule: $0, validPositions: Set(rulesToIndexes[$0]!)) }
    
    func fixPositions(rulePositions: [RuleWithValidPositions]) -> [RuleWithValidPositions] {
        guard let ruleWithOnePosition = rulePositions.first(where: { $0.validPositions.count == 1 }) else {
            return rulePositions
        }
        let newRulePositions: [RuleWithValidPositions] = rulePositions.compactMap {
            if $0 == ruleWithOnePosition {
                return nil
            }
            else {
                return RuleWithValidPositions(rule: $0.rule, validPositions: $0.validPositions.subtracting(ruleWithOnePosition.validPositions))
            }
        }
        return [ruleWithOnePosition] + fixPositions(rulePositions: newRulePositions)
    }
    let resultRulePositions = fixPositions(rulePositions: rulesWithValidPositions)

    let myTicket = tickets.first!
    let result = resultRulePositions.filter{$0.rule.name.starts(with: "departure ")}.reduce(1, {$0 * myTicket[$1.validPositions.first!]})
    
    print("Day 16 part 2 result: \(result)")
}

struct RuleWithValidPositions: Equatable {
    let rule: Rule
    var validPositions: Set<Int>
}

struct Rule: Hashable, Equatable {
    let name: String
    let firstRangeMin: Int
    let firstRangeMax: Int
    let secondRangeMin: Int
    let secondRangeMax: Int
    func isValid(_ number: Int) -> Bool {
        return (number >= firstRangeMin && number <= firstRangeMax) || (number >= secondRangeMin && number <= secondRangeMax)
    }
}

private func calculateTicketScanningErrorRate(tickets: [[Int]], rules: [Rule]) -> Int {
    return tickets.reduce(0, {
        return $0 + $1.reduce(0, {
            for rule in rules {
                if rule.isValid($1) {
                    return $0
                }
            }
            return $0 + $1
        })
    })
}
