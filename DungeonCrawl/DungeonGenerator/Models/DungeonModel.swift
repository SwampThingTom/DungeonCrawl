//
//  DungeonModel.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 4/27/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

struct DungeonModel {
    let map: GridMap
    let rooms: [RoomModel]
}

struct RoomModel: Equatable {
    let bounds: GridRect
}
