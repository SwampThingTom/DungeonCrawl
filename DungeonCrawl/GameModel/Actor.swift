//
//  Actor.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/15/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol Actor: class {
    /// Identifies the unique Sprite object associated with this Actor.
    var spriteName: String { get }
    /// Name shown in messages.
    var displayName: String { get }
    var cell: GridCell { get set }
    var isDead: Bool { get }
    var gameLevel: LevelProviding? { get set }
}

protocol AIActor: Actor {
    var enemyType: EnemyType { get }
    func turnAction() -> TurnAction
}
