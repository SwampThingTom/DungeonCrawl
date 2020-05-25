//
//  DungeonDecorations.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/10/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

struct EnemyModel: Equatable {
    let enemyType: EnemyType
    let cell: GridCell
}

struct Treasure: Equatable {
    let gold: Int
    let cell: GridCell
}

struct DungeonDecorations: Equatable {
    let playerStartCell: GridCell
    let enemies: [EnemyModel]
    let treasure: [Treasure]
}
