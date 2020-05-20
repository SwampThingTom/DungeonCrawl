//
//  GridMap+Description.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/20/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import Foundation

extension Tile {
    
    var description: String {
        switch self {
        case .wall:
            return "*"
        case .floor:
            return "_"
        case .door:
            return "$"
        }
    }
}

extension GridMap {
    
    var description: String {
        var description = String()
        for y in 0 ..< size.height {
            for x in 0 ..< size.width {
                let tile = self.tile(at: GridCell(x: x, y: y))
                description += tile?.description ?? "?"
            }
            description += "\n"
        }
        return description
    }
}
