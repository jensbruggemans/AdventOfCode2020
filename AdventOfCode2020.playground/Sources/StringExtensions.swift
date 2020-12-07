import Foundation

public extension String {
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func characterAt(_ i: Int) -> Character {
        return Array(self)[i]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    func firstRegexMatch(_ regex:String) -> [String] {
        let regex = try! NSRegularExpression(pattern: regex)
        var result: [String] = []
        if let match = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            for i in 0..<match.numberOfRanges {
                let range = match.range(at: i)
                guard range.location != NSNotFound else { continue }
                let stringRange = Range(range, in: self)!
                let foundString = self[stringRange]
                result.append(String(foundString))
            }
        }
        return result
    }
    
    func allRegexMatches(_ regex: String) -> [[String]] {
        let regex = try! NSRegularExpression(pattern: regex)
        var result: [[String]] = []
        for match in regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            var partialResult = [String]()
            for i in 0..<match.numberOfRanges {
                let range = match.range(at: i)
                guard range.location != NSNotFound else { continue }
                let stringRange = Range(range, in: self)!
                let foundString = self[stringRange]
                partialResult.append(String(foundString))
            }
            result.append(partialResult)
        }
        return result
    }
}
