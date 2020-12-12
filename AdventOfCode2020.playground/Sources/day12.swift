import Foundation

public func day12() {
    let fileURL = Bundle.main.url(forResource: "day12", withExtension: "txt")
    let content: String = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8).trimmingCharacters(in: CharacterSet.newlines)
    let lines = content.components(separatedBy: "\n")
    let instructions: [Instruction] = lines.map {
        return Instruction(action: $0.characterAt(0), value: Int($0[1..<$0.count])!)
    }
    print("Day 12 part 1 result: \(navigate1(instructions: instructions))")
    print("Day 12 part 2 result: \(navigate2(instructions: instructions))")
}

private struct Instruction {
    let action: Character
    let value: Int
}

private func navigate1(instructions: [Instruction]) -> Int {
    var positionNS = 0
    var positionEW = 0
    var degrees = 0
    for instruction in instructions {
        let action = instruction.action
        let value = instruction.value
        switch action {
        case "N":
            positionNS += value
        case "S":
            positionNS -= value
        case "E":
            positionEW += value
        case "W":
            positionEW -= value
        case "L":
            degrees -= value
            degrees = (degrees + 360) % 360
        case "R":
            degrees += value
            degrees = degrees % 360
        case "F":
            if degrees == 0 {
                positionEW += value
            } else if degrees == 90 {
                positionNS -= value
            } else if degrees == 180 {
                positionEW -= value
            } else if degrees == 270 {
                positionNS += value
            }
        default:
            break
        }
    }
    return abs(positionNS) + abs(positionEW)
}

private func navigate2(instructions: [Instruction]) -> Int {
    var positionNS = 0
    var positionEW = 0
    var waypointNS = 1
    var waypointEW = 10
    for instruction in instructions {
        let action = instruction.action
        let value = instruction.value
        switch action {
        case "N":
            waypointNS += value
        case "S":
            waypointNS -= value
        case "E":
            waypointEW += value
        case "W":
            waypointEW -= value
        case "L":
            (waypointNS, waypointEW) = rotateWaypoint(ns: waypointNS, ew: waypointEW, degrees: -value)
        case "R":
            (waypointNS, waypointEW) = rotateWaypoint(ns: waypointNS, ew: waypointEW, degrees: value)
        case "F":
            positionEW += waypointEW * value
            positionNS += waypointNS * value
        default:
            break
        }
    }
    return abs(positionNS) + abs(positionEW)
}

func rotateWaypoint(ns: Int, ew: Int, degrees: Int) -> (Int, Int) {
    switch degrees {
    case 90, -270:
        return (-ew, ns)
    case 180, -180:
        return (-ns, -ew)
    case -90, 270:
        return (ew, -ns)
    default:
        return (ns, ew)
    }
}
