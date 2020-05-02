//
//  MazeGenerator.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/2/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

protocol MazeMapSource: GridMap {
    func openTiles() -> [GridPoint]
    mutating func carve(tile: GridPoint)
}

protocol MazeGenerating {
    func generate(mapSource: MazeMapSource)
}

class MazeGenerator: MazeGenerating {
    
    func generate(mapSource: MazeMapSource) {
    }
}
