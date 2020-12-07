import Foundation

public func day4() {
    let fileURL = Bundle.main.url(forResource: "day4", withExtension: "txt")
    let content: String = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
    let passportDictionaryArray = content.components(separatedBy: "\n\n").map{$0.components(separatedBy: CharacterSet(charactersIn: " \n")).reduce([String:String](), {
        let components = $1.components(separatedBy: ":")
        guard components.count == 2 else {
            return $0
        }
        var mutableDic = $0
        mutableDic[components[0]] = components[1]
        return mutableDic
    })}
    let result1 = passportDictionaryArray.reduce(0, {$0 + (Set($1.keys).isSuperset(of: ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]) ? 1 : 0)})
    
    print("Day 4 part 1 result: \(result1)")
    
    let result2 = passportDictionaryArray.reduce(0,
    {
        let hasAllKeys = Set($1.keys).isSuperset(of: ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])
        guard hasAllKeys else {
            return $0
        }
        guard let birthYear = Int($1["byr"]!), birthYear >= 1920 && birthYear <= 2002 else { return $0 }
        guard let issueYear = Int($1["iyr"]!), issueYear >= 2010 && issueYear <= 2020 else { return $0 }
        guard let expirationYear = Int($1["eyr"]!), expirationYear >= 2020 && expirationYear <= 2030 else { return $0 }

        let heightString = $1["hgt"]!
        let cmMatches = heightString.firstRegexMatch("^([0-9]+)cm$")
        let inMatches = heightString.firstRegexMatch("^([0-9]+)in$")
        if cmMatches.count == 2, let cm = Int(cmMatches[1]), cm >= 150 && cm <= 193 {
        } else if inMatches.count == 2, let inches = Int(inMatches[1]), inches >= 59 && inches <= 76 {
        } else {
            return $0
        }
        
        guard let hairColor = $1["hcl"], hairColor.firstRegexMatch("^#[0-9,a-f]{6}$").count == 1 else {
            return $0
        }
        
        guard let eyeColor = $1["ecl"], eyeColor.firstRegexMatch("^(?:amb|blu|brn|gry|grn|hzl|oth)$").count == 1 else {
            return $0
        }
        
        guard let passportId = $1["pid"], passportId.firstRegexMatch("^[0-9]{9}$").count == 1 else {
            return $0
        }
        
        return $0 + 1
    })
    print("Day 4 part 2 result: \(result2)")
}
