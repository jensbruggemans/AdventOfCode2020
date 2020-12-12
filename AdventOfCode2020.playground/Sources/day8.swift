import Foundation

public func day8() {
    let fileURL = Bundle.main.url(forResource: "day8", withExtension: "txt")
    let content: String = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8).trimmingCharacters(in: CharacterSet.newlines)
    let lines = content.components(separatedBy: "\n")
    let instructions: [Instruction] = lines.map {
        let components = $0.components(separatedBy: " ")
        return Instruction(opcode: components[0], value: Int(components[1])!)
    }
    print("Day 8 part 1 result: \(run(instructions: instructions).1)")
    
    var result2: (Bool, Int)? = nil
    for i in 0..<instructions.count {
        let instruction = instructions[i]
        if instruction.opcode == "jmp" || instruction.opcode == "nop" {
            var instructionsCopy = instructions
            instructionsCopy[i] = Instruction(opcode: instruction.opcode == "jmp" ? "nop" : "jmp", value: instruction.value)
            let result = run(instructions: instructionsCopy)
            if result.0 {
                result2 = result
                break
            }
        }
    }
    print("Day 8 part 2 result: \(result2!.1)")
}

private struct Instruction {
    let opcode: String
    let value: Int
}

private func run(instructions: [Instruction]) -> (Bool, Int) {
    var instructionIndex = 0
    var pastInstructions = Set<Int>()
    var accumulator: Int = 0
    while !pastInstructions.contains(instructionIndex) && instructionIndex < instructions.count {
        pastInstructions.insert(instructionIndex)
        let instruction = instructions[instructionIndex]
        switch instruction.opcode {
        case "acc":
            accumulator += instruction.value
            instructionIndex += 1
        case "jmp":
            instructionIndex += instruction.value
        default:
            instructionIndex += 1
        }
    }
    return (instructionIndex == instructions.count, accumulator)
}
