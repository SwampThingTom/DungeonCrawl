//
//  DungeonGenerator.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 4/27/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

protocol DungeonGenerating {
    func generate() -> DungeonModel
}

class DungeonGenerator: DungeonGenerating {
    func generate() -> DungeonModel {
        return DungeonModel()
    }
}
