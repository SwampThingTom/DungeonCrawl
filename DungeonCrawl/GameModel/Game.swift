//
//  Game.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/14/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class Game {
    
    var level: DungeonLevel
    
    init(dungeonGenerator: DungeonGenerating, dungeonDecorator: DungeonDecorating, dungeonSize: GridSize) {
        let dungeonModel = dungeonGenerator.generate(size: dungeonSize)
        let decorations = dungeonDecorator.decorate(dungeon: dungeonModel)
        let playerActor = PlayerActor(name: "Player", cell: decorations.playerStartCell)
        let enemyActors: [EnemyActor] = decorations.enemies.enumerated().map {
            let name = "Ghost_\($0)"
            return EnemyActor(name: name, model: $1)
        }
        level = DungeonLevel(map: dungeonModel.map, player: playerActor, actors: enemyActors)
    }
}

struct DungeonLevel: LevelProviding {
    let map: GridMap
    var player: Actor
    var actors: [AIActor]
}

struct PlayerActor: Actor {
    let name: String
    var cell: GridCell
    
    func doTurnAction(_ action: TurnAction) -> Animation? {
        return nil
    }
}

struct EnemyActor: AIActor {
    
    let name: String
    let enemyType: EnemyType
    var cell: GridCell
    
    init(name: String, model: EnemyModel) {
        self.name = name
        self.enemyType = model.enemyType
        self.cell = model.cell
    }
    
    func turnAction(level: LevelProviding) -> TurnAction {
        return .nothing
    }
    
    func doTurnAction(_ action: TurnAction) -> Animation? {
        return nil
    }
}
