//
//  DungeonModel.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 4/27/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

struct DungeonModel {
    let size: GridSize
    let tiles: [[Tile]]
    let rooms: [RoomModel]
}

struct RoomModel {
    let bounds: GridRect
}

struct GridRect: Equatable {
    let origin: GridPoint
    let size: GridSize
    
    var tileXRange: CountableRange<Int> {
        origin.x ..< origin.x + size.width
    }
    
    var tileYRange: CountableRange<Int> {
        origin.y ..< origin.y + size.height
    }
    
    init(x: Int, y: Int, width: Int, height: Int) {
        origin = GridPoint(x: x, y: y)
        size = GridSize(width: width, height: height)
    }
}

struct GridPoint: Equatable {
    let x: Int
    let y: Int
}

struct GridSize: Equatable {
    let width: Int
    let height: Int
}
