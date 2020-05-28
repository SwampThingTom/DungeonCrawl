//
//  OccupiedCells.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/28/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class OccupiedCells {
    
    private var occupiedCells = Set<GridCell>()
    
    /// Indicates whether a cell is occupied.
    func isOccupied(cell: GridCell) -> Bool {
        return occupiedCells.contains(cell)
    }
    
    /// Marks the cell as occupied.
    func occupy(cell: GridCell) {
        occupiedCells.insert(cell)
    }
    
    /// Repeatedly calls a block to get a random cell until it returns one that is not occupied.
    /// - Parameter randomCell: A block that returns a cell.
    /// - Returns: A cell that is guaranteed to be unoccupied.
    ///
    /// - Warning:
    /// If `randomCell` never returns an unoccupied cell, this function will never return.
    func findEmptyCell(randomCell: () -> GridCell) -> GridCell {
        var cell: GridCell
        repeat {
            cell = randomCell()
        } while occupiedCells.contains(cell)
        return cell
    }
}
