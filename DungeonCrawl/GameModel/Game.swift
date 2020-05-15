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
    
    func takeTurn(playerAction: TurnAction) -> [ActorAnimation] {
        let playerAnimation = takePlayerTurn(player: level.player, action: playerAction)
        let actorAnimations = takeActorTurns(for: level.actors)
        return combinedAnimations(playerAnimation: playerAnimation, actorAnimations: actorAnimations)
    }
    
    private func takePlayerTurn(player: Actor, action: TurnAction) -> ActorAnimation? {
        let playerTurnAnimation = level.player.doTurnAction(action)
        return actorAnimation(actor: level.player, animation: playerTurnAnimation)
    }
    
    private func takeActorTurns(for actors: [AIActor]) -> [ActorAnimation] {
        return actors.compactMap { actor in
            let action = actor.turnAction(level: level)
            let animation = actor.doTurnAction(action)
            return actorAnimation(actor: actor, animation: animation)
        }
    }
    
    private func actorAnimation(actor: Actor, animation: Animation?) -> ActorAnimation? {
        guard let animation = animation else { return nil }
        return ActorAnimation(actor: actor, animation: animation)
    }
    
    private func combinedAnimations(playerAnimation: ActorAnimation?,
                                    actorAnimations: [ActorAnimation]) -> [ActorAnimation] {
        if let playerAnimation = playerAnimation {
            return [playerAnimation] + actorAnimations
        }
        return actorAnimations
    }
}

struct DungeonLevel: LevelProviding {
    let map: GridMap
    var player: Actor
    var actors: [AIActor]
}

class PlayerActor: Actor {
    let name: String
    var cell: GridCell
    
    init(name: String, cell: GridCell) {
        self.name = name
        self.cell = cell
    }
    
    func doTurnAction(_ action: TurnAction) -> Animation? {
        switch action {
        case .attack(let heading):
            return .attack(heading: heading)
        case .move(let cell, let heading):
            self.cell = cell
            return .move(to: cell, heading: heading)
        case .nothing:
            return nil
        }
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

typealias ActorAnimation = (actor: Actor, animation: Animation)
