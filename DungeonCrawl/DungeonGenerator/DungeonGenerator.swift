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
        return DungeonModel(size: size)
    }
}
