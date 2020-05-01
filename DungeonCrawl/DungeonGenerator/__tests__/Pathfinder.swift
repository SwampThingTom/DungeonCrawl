//
//  Pathfinder.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 4/29/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

@testable import DungeonCrawl

class Pathfinder {
    
    private let adjacentNodes = [
        AdjacentNode(offset: GridPoint(x: 0, y: -1), cost: 10),
        AdjacentNode(offset: GridPoint(x: -1, y: 0), cost: 10),
        AdjacentNode(offset: GridPoint(x: 1, y: 0), cost: 10),
        AdjacentNode(offset: GridPoint(x: 0, y: 1), cost: 10)
    ]
    
    private let tiles: [[Tile]]
    private let pathMap: [[PathNode]]
    
    private var mapWidth: Int {
        return tiles.count
    }
    
    private var mapHeight: Int {
        return tiles.count > 0 ? tiles[0].count : 0
    }

    init(tiles: [[Tile]]) {
        self.tiles = tiles
        let mapSize = GridSize(width: tiles.count, height: tiles[0].count)
        pathMap = PathNode.createNodeMap(size: mapSize)
    }
    
    func findPath(from start: GridPoint, to end: GridPoint) -> [GridPoint] {
        guard let bestPathNode = findBestPath(from: start, to: end) else {
            return []
        }
        return bestPathNode.map { $0.tile }.reversed()
    }
    
    private func findBestPath (from start: GridPoint, to end: GridPoint) -> PathNode? {
        addToOpenList(node: pathMap[start.x][start.y])
        while !openList.isEmpty {
            let node = bestOpenNode
            if node.tile == end {
                return node
            }
            
            for adjacent in adjacentNodes {
                let adjacentTile = GridPoint(x: node.tile.x + adjacent.offset.x,
                                             y: node.tile.y + adjacent.offset.y)
                if !tileIsOnMap(adjacentTile) || !tileIsMoveable(adjacentTile) {
                    continue
                }
                
                let adjacentNode = pathMap[adjacentTile.x][adjacentTile.y]
                if adjacentNode.isClosed {
                    continue
                }
                
                let costFromStart = node.costFromStart + adjacent.cost
                if !adjacentNode.isOpen {
                    let costToDest = 10 * (abs(end.x - adjacentTile.x) + abs(end.y - adjacentTile.y))
                    addToOpenList(node: adjacentNode,
                                  previous: node,
                                  costFromStart: costFromStart,
                                  costToDest: costToDest)
                } else if costFromStart < adjacentNode.costFromStart {
                    adjacentNode.update(previous: node, costFromStart: costFromStart)
                }
            }
        }
        
        return nil
    }

    private func tileIsOnMap(_ tile: GridPoint) -> Bool {
        return 0 ..< mapWidth ~= tile.x && 0 ..< mapHeight ~= tile.y
    }
    
    private func tileIsMoveable(_ tile: GridPoint) -> Bool {
        let adjacentTileIsFree = tiles[tile.x][tile.y] == .floor
        return adjacentTileIsFree
    }

    /// MARK: Open Nodes
    
    private var openList = [PathNode]()

    private var bestOpenNode: PathNode {
        openList.sort()
        let node = openList.remove(at: 0)
        node.close()
        return node;
    }
    
    private func addToOpenList(node: PathNode) {
        openList.append(node)
        node.open()
    }

    private func addToOpenList(node: PathNode, previous: PathNode, costFromStart: Int, costToDest: Int) {
        openList.append(node)
        node.open()
        node.update(previous: previous, costFromStart: costFromStart, costToDest: costToDest)
    }
}

struct AdjacentNode {
    let offset: GridPoint
    let cost: Int
}

enum NodeStatus {
    case unknown
    case open
    case closed
}

class PathNode: Equatable, Comparable {
    
    let tile: GridPoint
    private(set) var status: NodeStatus = .unknown
    private(set) var previous: PathNode? = nil
    private(set) var costFromStart: Int = 0
    private(set) var estimatedCostToDestination: Int = 0

    var totalCost: Int {
        return costFromStart + estimatedCostToDestination
    }
    
    var isOpen: Bool {
        status == .open
    }
    
    var isClosed: Bool {
        status == .closed
    }
    
    static func createNodeMap(size: GridSize) -> [[PathNode]] {
        let rowRange = [Int](0 ..< size.width)
        let columnRange = [Int](0 ..< size.height)
        return rowRange.map { x in
            columnRange.map { y in
                PathNode(tile: GridPoint(x: x, y: y))
            }
        }
    }
    
    private init(tile: GridPoint) {
        self.tile = tile
    }
    
    func open() {
        status = .open
    }
    
    func close() {
        status = .closed
    }

    func update(previous: PathNode, costFromStart: Int) {
        self.previous = previous;
        self.costFromStart = costFromStart
    }
    
    func update(previous: PathNode, costFromStart: Int, costToDest: Int) {
        self.previous = previous
        self.costFromStart = costFromStart
        estimatedCostToDestination = costToDest
    }
    
    static func == (lhs: PathNode, rhs: PathNode) -> Bool {
        return lhs.tile == rhs.tile
    }
    
    static func < (lhs: PathNode, rhs: PathNode) -> Bool {
        return lhs.totalCost < rhs.totalCost
    }
}

extension PathNode: Sequence {
    
    func makeIterator() -> PathNodeIterator {
        return PathNodeIterator(pathNode: self)
    }
}

struct PathNodeIterator: IteratorProtocol {
    
    private var head: PathNode?
    
    init(pathNode: PathNode) {
        head = pathNode
    }
    
    mutating func next() -> PathNode? {
        let next = head
        head = head?.previous
        return next
    }
}
