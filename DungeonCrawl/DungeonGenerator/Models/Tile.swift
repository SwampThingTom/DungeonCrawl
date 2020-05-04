//
//  Tile.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 4/27/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

enum Tile {
    case wall
    case floor
    case door
}

extension Tile {
    
    var description: String {
        switch self {
        case .wall:
            return "*"
        case .floor:
            return "_"
        case .door:
            return "+"
        }
    }
}
