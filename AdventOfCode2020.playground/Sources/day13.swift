import Foundation

public func day13() {
    let fileURL = Bundle.main.url(forResource: "day13", withExtension: "txt")
    let content: String = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8).trimmingCharacters(in: CharacterSet.newlines)
    let lines = content.components(separatedBy: "\n")
    let arrival = Int(lines[0])!
    let busses = lines[1].components(separatedBy: ",").compactMap{ Int($0) }
    var earliestDeparture = Int.max
    var earliestBus = 0
    for bus in busses {
        let remainder = arrival % bus
        if remainder == 0 {
            earliestDeparture = arrival
        } else {
            let nextDeparture = (1 + arrival / bus) * bus
            if nextDeparture < earliestDeparture {
                earliestDeparture = nextDeparture
                earliestBus = bus
            }
        }
    }
    
    let busDepartures: [BusDeparture] = lines[1].components(separatedBy: ",").enumerated().compactMap{
        index, string in
        if let id = Int(string) {
            return BusDeparture(id: id, offset: index)
        }
        return nil
    }
    print("Day 13 part 1 result: \(earliestBus * (earliestDeparture - arrival))")
    print("Day 13 part 2 result: \(busDepartures.firstValidDeparture())")
}

extension Array where Element == BusDeparture {
    func firstValidDeparture() -> Int {
        var increment = 1
        var departure = 0
        for busDeparture in self {
            while (departure + busDeparture.offset) % busDeparture.id != 0 {
                departure += increment
            }
            increment = increment * busDeparture.id
        }
        return departure
    }
}

struct BusDeparture {
    let id: Int
    let offset: Int
}
