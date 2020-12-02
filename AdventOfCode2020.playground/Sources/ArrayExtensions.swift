import Foundation

public extension Array where Element: Equatable {
    func amountOf(_ element: Element) -> Int {
        return self.filter{$0 == element}.count
    }
}
