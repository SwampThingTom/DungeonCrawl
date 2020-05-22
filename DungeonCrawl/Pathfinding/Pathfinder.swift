//
//  Pathfinder.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 4/29/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

protocol Pathfinding {
    
    /// Returns a sequence of `GridCell`that defines a path from a start cell to an end cell.
    /// - Note: Returns an empty sequence if there is no path or if the start and end cells are the same.
    func findPath(from start: GridCell, to end: GridCell) -> [GridCell]
}

/// Implementation of `Pathfinding` using A* algorithm.
///
/// - SeeAlso: http://csis.pace.edu/~benjamin/teaching/cs627/webfiles/Astar.pdf
/// - SeeAlso: http://swampthingtom.blogspot.com/2007/07/pathfinding-sample-using.html
class Pathfinder: Pathfinding {
    
    private let adjacentNodes = [
        AdjacentNode(offset: GridCell(x: 0, y: -1), cost: 10),
        AdjacentNode(offset: GridCell(x: -1, y: 0), cost: 10),
        AdjacentNode(offset: GridCell(x: 1, y: 0), cost: 10),
        AdjacentNode(offset: GridCell(x: 0, y: 1), cost: 10)
    ]
    
    private let map: GridMap
    private let pathMap: [[PathNode]]

    init(map: GridMap) {
        self.map = map
        pathMap = PathNode.createNodeMap(size: map.size)
    }
    
    func findPath(from start: GridCell, to end: GridCell) -> [GridCell] {
        guard map.isValid(cell: start) && map.isValid(cell: end) else {
            return []
        }
        guard let bestPathNode = findBestPath(from: start, to: end) else {
            return []
        }
        return bestPathNode.dropLast().map { $0.cell }.reversed()
    }
    
    private func findBestPath (from start: GridCell, to end: GridCell) -> PathNode? {
        reset()
        addToOpenList(node: pathMap[start.x][start.y])
        while !openList.isEmpty {
            let node = bestOpenNode
            if node.cell == end {
                return node
            }
            
            for adjacent in adjacentNodes {
                let adjacentCell = GridCell(x: node.cell.x + adjacent.offset.x,
                                             y: node.cell.y + adjacent.offset.y)
                if !map.isValid(cell: adjacentCell) || cellHasObstacle(adjacentCell) {
                    continue
                }
                
                let adjacentNode = pathMap[adjacentCell.x][adjacentCell.y]
                if adjacentNode.isClosed {
                    continue
                }
                
                let costFromStart = node.costFromStart + adjacent.cost
                if !adjacentNode.isOpen {
                    let costToDest = 10 * (abs(end.x - adjacentCell.x) + abs(end.y - adjacentCell.y))
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
    
    private func reset() {
        openList.removeAll()
        pathMap.forEach { $0.forEach { $0.reset() } }
    }
    
    private func cellHasObstacle(_ cell: GridCell) -> Bool {
        return map.tile(at: cell)?.isObstacle ?? true
    }

    // MARK: Open Nodes
    
    private var openList = [PathNode]()

    private var bestOpenNode: PathNode {
        openList.sort()
        let node = openList.remove(at: 0)
        node.close()
        return node
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
    let offset: GridCell
    let cost: Int
}

enum NodeStatus {
    case unknown
    case open
    case closed
}

class PathNode: Equatable, Comparable {
    
    let cell: GridCell
    private(set) var status: NodeStatus = .unknown
    private(set) var previous: PathNode?
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
                PathNode(cell: GridCell(x: x, y: y))
            }
        }
    }
    
    private init(cell: GridCell) {
        self.cell = cell
    }
    
    func reset() {
        status = .unknown
        previous = nil
        costFromStart = 0
        estimatedCostToDestination = 0
    }
    
    func open() {
        status = .open
    }
    
    func close() {
        status = .closed
    }

    func update(previous: PathNode, costFromStart: Int) {
        self.previous = previous
        self.costFromStart = costFromStart
    }
    
    func update(previous: PathNode, costFromStart: Int, costToDest: Int) {
        self.previous = previous
        self.costFromStart = costFromStart
        estimatedCostToDestination = costToDest
    }
    
    static func == (lhs: PathNode, rhs: PathNode) -> Bool {
        return lhs.cell == rhs.cell
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
