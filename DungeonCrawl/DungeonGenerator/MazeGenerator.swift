//
//  MazeGenerator.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/2/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

protocol MazeGenerating {
    func generate(map: inout MutableGridMap)
}

class MazeGenerator: MazeGenerating {
    
    func generate(map: inout MutableGridMap) {
        while true {
            let openTiles = openMapTiles(in: map)
            if openTiles.isEmpty {
                return
            }
            map.setCell(location: openTiles[0], tile: .floor)
        }
    }
    
    private func openMapTiles(in map: GridMap) -> [GridPoint] {
        var openTiles = [GridPoint]()
        for x in stride(from: 1, to: map.size.width, by: 2) {
            for y in stride(from: 1, to: map.size.height - 1, by: 2) {
                let location = GridPoint(x: x, y: y)
                if map.cell(location: location) == .empty {
                    openTiles.append(location)
                }
            }
        }
        return openTiles
    }

}
