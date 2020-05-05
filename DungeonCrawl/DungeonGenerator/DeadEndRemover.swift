//
//  DeadEndRemover.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/4/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

typealias DeadEnd = (cell: GridCell, exit: Direction)

protocol DeadEndRemoving {
    func removeDeadEnds(from map: inout MutableGridMap)
}

class DeadEndRemover: DeadEndRemoving {
    
    func removeDeadEnds(from map: inout MutableGridMap) {
        for deadEnd in findDeadEnds(in: map) {
            remove(deadEnd, from: &map)
        }
    }
    
    private func findDeadEnds(in map: GridMap) -> [DeadEnd] {
        var deadEnds = [DeadEnd]()
        for x in 0 ..< map.size.width {
            for y in 0 ..< map.size.height {
                let location = GridCell(x: x, y: y)
                guard map.tile(at: location) == .floor else {
                    continue
                }
                let exits = map.exits(for: location)
                if exits.count == 1 {
                    deadEnds.append((cell: location, exit: exits[0]))
                }
            }
        }
        return deadEnds
    }
    
    private func remove(_ deadEnd: DeadEnd, from map: inout MutableGridMap) {
        var nextDeadEnd = deadEnd
        while true {
            let cell = nextDeadEnd.cell
            map.setTile(at: cell, tile: .wall)
            let nextCell = cell.neighbor(direction: nextDeadEnd.exit)
            let nextCellExits = map.exits(for: nextCell)
            if nextCellExits.count != 1 {
                return
            }
            nextDeadEnd = (cell: nextCell, exit: nextCellExits[0])
        }
    }
}

extension GridMap {
    
    func exits(for location: GridCell) -> [Direction] {
        var exits = [Direction]()
        for neighbor in neighboringCells(location) {
            guard let cell = tile(at: neighbor.cell) else {
                continue
            }
            if !cell.isObstacle {
                exits.append(neighbor.direction)
            }
        }
        return exits
    }
}
