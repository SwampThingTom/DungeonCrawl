//
//  GridMap+Equatable.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/3/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

@testable import DungeonCrawl

import Foundation

extension GridMap  {
    
    func isEqual(_ map: GridMap) -> Bool {
        guard size == map.size else { return false }
        for x in 0 ..< size.width {
            for y in 0 ..< size.height {
                let cell = GridCell(x: x, y: y)
                if tile(at: cell) != map.tile(at: cell) {
                    return false
                }
            }
        }
        return true
    }
}
