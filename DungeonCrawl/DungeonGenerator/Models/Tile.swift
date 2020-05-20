//
//  Tile.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 4/27/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

enum Tile {
    case wall
    case floor
    case door
    
    var isObstacle: Bool {
        switch self {
        case .wall: return true
        case .floor: return false
        case .door: return false
        }
    }
}
