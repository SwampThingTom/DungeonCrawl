//
//  DungeonGenerator.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 4/27/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import CoreGraphics
import Foundation

protocol DungeonGenerating {
    func generate(size: CGSize) -> DungeonModel
}

class DungeonGenerator: DungeonGenerating {
    func generate(size: CGSize) -> DungeonModel {
        let tiles: [[Tile]] = .init(repeating: .init(repeating: .empty,
                                                     count: Int(size.height)),
                                    count: Int(size.width))
        return DungeonModel(size: size, tiles: tiles)
    }
}
