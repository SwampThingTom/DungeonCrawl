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
    func doTurnAction(_ action: TurnAction) -> Animation?
}

protocol AIActor: Actor {
    var enemyType: EnemyType { get }
    func turnAction() -> TurnAction
}

enum TurnAction: Equatable {
    case attack(direction: Direction)
    case move(to: GridCell, direction: Direction)
    case nothing
}

enum Animation: Equatable {
    case attack(heading: Direction)
    case death
    case move(to: GridCell, heading: Direction)
}

enum EnemyType: Equatable {
    case ghost
}

extension EnemyType: CustomStringConvertible {
    var description: String {
        switch self {
        case .ghost: return "ghost"
        }
    }
}
