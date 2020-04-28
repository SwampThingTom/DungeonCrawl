//
//  DungeonModel.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 4/27/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

struct DungeonModel {
    let size: TileSize
    let tiles: [[Tile]]
    let rooms: [RoomModel]
}

struct RoomModel {
    let bounds: TileRect
}

struct TileRect: Equatable {
    let origin: TilePoint
    let size: TileSize
    
    var tileXRange: CountableRange<Int> {
        origin.x ..< origin.x + size.width
    }
    
    var tileYRange: CountableRange<Int> {
        origin.y ..< origin.y + size.height
    }
    
    init(x: Int, y: Int, width: Int, height: Int) {
        origin = TilePoint(x: x, y: y)
        size = TileSize(width: width, height: height)
    }
}

struct TilePoint: Equatable {
    let x: Int
    let y: Int
}

struct TileSize: Equatable {
    let width: Int
    let height: Int
}
