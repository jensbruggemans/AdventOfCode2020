import Foundation

public func day18() {
    let fileURL = Bundle.main.url(forResource: "day18", withExtension: "txt")
    let content: String = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8).trimmingCharacters(in: CharacterSet.newlines)
    let lines = content.components(separatedBy: "\n")
    let expressions: [[ExpressionComponent]] = lines.map{
        $0.compactMap {
            if let number = Int(String($0)) {
                return .number(number)
            } else if $0 == "+" {
                return .add
            } else if $0 == "*" {
                return .multiply
            } else if $0 == "(" {
                return .openingBracket
            } else if $0 == ")" {
                return .closingBracket
            }
            return nil
        }
    }
    print("Day 18 part 1 result: \(expressions.map{ $0.calculate() }.reduce(0, { $0 + $1 }))")
    print("Day 18 part 2 result: \(expressions.map{ $0.calculateAdditionsBeforeMultiplications() }.reduce(0, { $0 + $1 }))")
}

enum ExpressionComponent: Equatable {
    case add
    case multiply
    case number(Int)
    case openingBracket
    case closingBracket
    case subExpression([ExpressionComponent])
}

extension ExpressionComponent: CustomStringConvertible {
    var description: String {
        switch self {
        case .add:
            return "+"
        case .multiply:
            return "*"
        case .number(let number):
            return "\(number)"
        case .openingBracket:
            return "("
        case .closingBracket:
            return ")"
        case .subExpression(let expressions):
            return "( \(expressions.map{$0.description}) )"
        }
    }
}

extension Array where Element == ExpressionComponent {
    func calculate() -> Int {
        var resultAtDepth = [Int: Int]()
        var lastOperandAtDepth = [Int: ExpressionComponent]()
        var depth: Int = 0
        
        for component in self {
            switch component {
            case .number(let number):
                if lastOperandAtDepth[depth] == .add {
                    resultAtDepth[depth] = (resultAtDepth[depth] ?? 0) + number
                } else if lastOperandAtDepth[depth] == .multiply {
                    resultAtDepth[depth] = (resultAtDepth[depth] ?? 0) * number
                } else if lastOperandAtDepth[depth] == nil {
                    resultAtDepth[depth] = number
                }
            case .openingBracket:
                depth += 1
                resultAtDepth[depth] = 0
                lastOperandAtDepth[depth] = nil
            case .closingBracket:
                if lastOperandAtDepth[depth-1] == .add {
                    resultAtDepth[depth-1] = (resultAtDepth[depth-1] ?? 0) + (resultAtDepth[depth] ?? 0)
                } else if lastOperandAtDepth[depth-1] == .multiply {
                    resultAtDepth[depth-1] = (resultAtDepth[depth-1] ?? 0) * (resultAtDepth[depth] ?? 0)
                } else if lastOperandAtDepth[depth-1] == nil {
                    resultAtDepth[depth-1] = resultAtDepth[depth]
                }
                depth -= 1
            default:
                lastOperandAtDepth[depth] = component
            }
        }
        return resultAtDepth[0]!
    }
    
    func calculateAdditionsBeforeMultiplications() -> Int {
        return self.convertingBracketsToSubExpressions().calculateAdditionsThenMultiply()
    }
    
    private func convertingBracketsToSubExpressions() -> Self {
        var convertedArrayAtDepth = [0: Self()]
        var depth = 0
        for component in self {
            switch component {
            case .openingBracket:
                depth += 1
                convertedArrayAtDepth[depth] = Self()
            case .closingBracket:
                convertedArrayAtDepth[depth-1] = convertedArrayAtDepth[depth-1]! + [ExpressionComponent.subExpression(convertedArrayAtDepth[depth]!)]
                depth -= 1
            default:
                convertedArrayAtDepth[depth] = convertedArrayAtDepth[depth]! + [component]
            }
        }
        return convertedArrayAtDepth[0]!
    }
    
    private func flatteningAdditions() -> Self {
        var flattenedArray = Self()
        var previousWasAdd = false
        for component in self {
            switch component {
            case .add:
                previousWasAdd = true
            case .number(let number):
                if previousWasAdd, let previous = flattenedArray.popLast(), case let ExpressionComponent.number(previousNumber) = previous {
                    flattenedArray.append(ExpressionComponent.number(previousNumber + number))
                } else {
                    flattenedArray.append(component)
                }
                previousWasAdd = false
            case .subExpression(let subExpression):
                if previousWasAdd, let previous = flattenedArray.popLast(), case let ExpressionComponent.number(previousNumber) = previous {
                    flattenedArray.append(ExpressionComponent.number(previousNumber + subExpression.calculateAdditionsThenMultiply()))
                } else {
                    flattenedArray.append(.number(subExpression.calculateAdditionsThenMultiply()))
                }
                previousWasAdd = false
            default:
                previousWasAdd = false
                flattenedArray.append(component)
            }
        }
        return flattenedArray
    }
    
    private func calculateAdditionsThenMultiply() -> Int {
        let flattenedArray = self.flatteningAdditions()
        let onlyNumbers: [Int] = flattenedArray.compactMap {
            if case let ExpressionComponent.number(number) = $0 {
                return number
            } else {
                return nil
            }
        }
        return onlyNumbers.reduce(1, { $0 * $1 })
    }
}
