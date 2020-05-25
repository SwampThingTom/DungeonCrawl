//
//  DungeonDecorations.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/10/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

/// An enemy in the dungeon.
struct EnemyModel: Equatable {
    let enemyType: EnemyType
    let cell: GridCell
}

/// An item that can be carried and dropped.
struct ItemModel: Equatable {
    let item: Item
    let cell: GridCell
}

struct DungeonDecorations: Equatable {
    let playerStartCell: GridCell
    let enemies: [EnemyModel]
    let items: [ItemModel]
}
