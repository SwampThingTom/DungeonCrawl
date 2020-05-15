//
//  Actor.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/15/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol Actor: class {
    var name: String { get }
    var cell: GridCell { get set }
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

extension Actor {
    
    func doTurnAction(_ action: TurnAction) -> Animation? {
        switch action {
        case .attack(let heading):
            attack(heading: heading)
            return .attack(heading: heading)
        case .move(let cell, let heading):
            move(to: cell, heading: heading)
            return .move(to: cell, heading: heading)
        case .nothing:
            return nil
        }
    }
    
    private func attack(heading: Direction) {
    }
    
    private func move(to cell: GridCell, heading: Direction) {
        self.cell = cell
    }
}
