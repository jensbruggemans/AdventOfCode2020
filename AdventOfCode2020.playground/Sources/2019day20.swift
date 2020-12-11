import Foundation

public func y2019day20() {
    let fileURL = Bundle.main.url(forResource: "2019day20", withExtension: "txt")
    let content: String = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8).trimmingCharacters(in: CharacterSet.newlines)
    let rows = content.components(separatedBy: "\n").map{ Array($0) }
    let maxRow = rows.count
    let maxColumn = rows.map{ $0.count }.max() ?? 0
    var characterGrid: [[Character]] = Array(repeating: Array(repeating: " ", count: maxColumn), count: maxRow)
    for (row, characters) in rows.enumerated() {
        for (column, character) in characters.enumerated() {
            characterGrid[row][column] = character
        }
    }
    var tiles: [[Tile?]] = Array(repeating: Array(repeating: nil, count: maxColumn), count: maxRow)
    var portalNameToTile = [String:Tile]()
    var startTile: Tile?
    var endTile: Tile?
    
    for row in 0..<maxRow {
        for column in 0..<maxColumn {
            let character = characterGrid[row][column]
            guard character == "." else { continue }
            var portalName: String?
            if characterGrid[row-1][column].isLetter {
                portalName = String([characterGrid[row-2][column], characterGrid[row-1][column]])
            }
            if characterGrid[row+1][column].isLetter {
                portalName = String([characterGrid[row+1][column], characterGrid[row+2][column]])
            }
            if characterGrid[row][column-1].isLetter {
                portalName = String([characterGrid[row][column-2], characterGrid[row][column-1]])
            }
            if characterGrid[row][column+1].isLetter {
                portalName = String([characterGrid[row][column+1], characterGrid[row][column+2]])
            }
            let isOuterPortal = row == 2 || column == 2 || row == maxRow - 3 || column == maxColumn - 3
            let tile = Tile(row: row, column: column, portalName: portalName, isOuterPortal: isOuterPortal)
            if isOuterPortal {
                print("\(row) \(column) \(portalName)")
            }
            if portalName == "AA" {
                startTile = tile
            }
            if portalName == "ZZ" {
                endTile = tile
            }
            if let portalName = portalName {
                if let connectedPortalTile = portalNameToTile[portalName] {
                    tile.connectedPortalTile = connectedPortalTile
                    connectedPortalTile.connectedPortalTile = tile
                }
                else {
                    portalNameToTile[portalName] = tile
                }
            }
            if let tileAbove = tiles[row-1][column] {
                tileAbove.adjacentTiles.append(tile)
                tile.adjacentTiles.append(tileAbove)
            }
            if let tileRight = tiles[row][column-1] {
                tileRight.adjacentTiles.append(tile)
                tile.adjacentTiles.append(tileRight)
            }
            tiles[row][column] = tile
        }
    }
    
    func pathTo(destination: Tile, pathSoFar: [Tile], shortestSoFar: Int = Int.max) -> [Tile]? {
        let lastTile = pathSoFar.last!
        if lastTile == destination {
            return pathSoFar
        }
        if pathSoFar.count >= shortestSoFar {
            return nil
        }
        var shortestNewPath: [Tile]? = nil
        for nextTile in lastTile.allConnectingTiles {
            if !pathSoFar.contains(nextTile), let newPath = pathTo(destination: destination, pathSoFar: pathSoFar + [nextTile], shortestSoFar: shortestNewPath?.count ?? shortestSoFar) {
                shortestNewPath = newPath
            }
        }
        return shortestNewPath
    }
    
    let path = pathTo(destination: endTile!, pathSoFar: [startTile!])
    print(path!.count - 1)
    

    
    func pathTo2(destination: Tile, pathSoFar: [Tile], depthsToTiles: [Int: [Tile]] = [:], shortestSoFar: Int = Int.max, depth: Int = 0) -> [Tile]? {
        
        let lastTile = pathSoFar.last!
        if lastTile == destination {
            if depth == 0 {
                return pathSoFar
            }
            else {
                return nil
            }
        }
        if pathSoFar.count >= shortestSoFar {
            return nil
        }
        var shortestNewPath: [Tile]? = nil
        for nextTile in lastTile.allConnectingTiles {
            var nextDepth = depth
            if lastTile.isOuterPortal && nextTile.portalName != nil {
                nextDepth -= 1
            }
            else if lastTile.portalName != nil && nextTile.isOuterPortal {
                nextDepth += 1
            }
            
            if let array = depthsToTiles[nextDepth], array.contains(nextTile) {
                continue
            }
            if nextDepth > 30 || nextDepth < 0 {
                continue
            }
            
            var newDepthsToTiles = depthsToTiles
            newDepthsToTiles[nextDepth] = (newDepthsToTiles[nextDepth] ?? [Tile]()) + [nextTile]
            
            if let newPath = pathTo2(destination: destination, pathSoFar: pathSoFar + [nextTile], depthsToTiles: newDepthsToTiles, shortestSoFar: shortestNewPath?.count ?? shortestSoFar, depth: nextDepth) {
                shortestNewPath = newPath
            }
        }
        return shortestNewPath
    }
    
    let path2 = pathTo2(destination: endTile!, pathSoFar: [startTile!])
    for tile in path2! {
        if let portalName = tile.portalName {
            print("\(portalName) \(tile.isOuterPortal)")
        }
    }
    print(path2!.count - 1)
}

class Tile: Hashable {
    let row: Int
    let column: Int
    let portalName: String?
    var adjacentTiles: [Tile] = []
    var connectedPortalTile: Tile?
    var isOuterPortal: Bool
    var allConnectingTiles: [Tile] {
        if let connectedPortalTile = connectedPortalTile {
            return adjacentTiles + [connectedPortalTile]
        }
        return adjacentTiles
    }
    init(row: Int, column: Int, portalName: String?, isOuterPortal: Bool) {
        self.row = row
        self.column = column
        self.portalName = portalName
        self.isOuterPortal = isOuterPortal
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(column)
    }
    static func == (lhs: Tile, rhs: Tile) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row
    }
}

class Maze {
    
}
