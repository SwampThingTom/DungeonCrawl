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

extension RoomModel {
    
    func randomCell(using randomNumberGenerator: inout AnyRandomNumberGenerator) -> GridCell? {
        guard let x = bounds.gridXRange.randomElement(using: &randomNumberGenerator) else { return nil }
        guard let y = bounds.gridYRange.randomElement(using: &randomNumberGenerator) else { return nil }
        return GridCell(x: x, y: y)
    }
}
