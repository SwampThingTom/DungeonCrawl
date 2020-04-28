//
//  DungeonModel.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 4/27/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import CoreGraphics
import Foundation

struct DungeonModel {
    let size: CGSize
    let tiles: [[Tile]]
    let rooms: [RoomModel]
}

struct RoomModel {
    let bounds: CGRect
}
