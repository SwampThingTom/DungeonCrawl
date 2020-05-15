//
//  LevelProviding.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/10/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import SpriteKit

protocol LevelProviding {
    var map: GridMap { get }
    var player: Actor { get }
    var actors: [AIActor] { get }
}

protocol Actor {
    var name: String { get }
    var cell: GridCell { get }
    func doTurnAction(_ action: TurnAction) -> Animation?
}

protocol AIActor: Actor {
    var enemyType: EnemyType { get }
    func turnAction(level: LevelProviding) -> TurnAction
}

enum TurnAction {
    case attack(direction: Direction)
    case move(to: GridCell, direction: Direction)
    case nothing
}

enum Animation: Equatable {
    case attack(heading: Direction)
    case move(to: GridCell, heading: Direction)
}

enum EnemyType {
    case ghost
}
