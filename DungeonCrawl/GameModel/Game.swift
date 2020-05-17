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
        let playerActor = PlayerActor(spriteName: "player",
                                      displayName: "player",
                                      cell: decorations.playerStartCell)
        let enemyActors: [EnemyActor] = decorations.enemies.enumerated().map {
            let spriteName = "\($1.enemyType.description)_\($0)"
            return EnemyActor(spriteName: spriteName, model: $1)
        }
        level = DungeonLevel(map: dungeonModel.map, player: playerActor, actors: enemyActors)
    }
    
    func takeTurn(playerAction: TurnAction) -> [ActorAnimation] {
        let playerAnimation = takePlayerTurn(player: level.player, action: playerAction)
        let actorAnimations = takeActorTurns(for: level.actors)
        let deathAnimations = removeDeadActors()
        return combinedAnimations(playerAnimation: playerAnimation,
                                  actorAnimations: actorAnimations + deathAnimations)
    }
    
    private func takePlayerTurn(player: Actor, action: TurnAction) -> ActorAnimation? {
        let playerTurnAnimation = level.player.doTurnAction(action)
        return actorAnimation(actor: level.player, animation: playerTurnAnimation)
    }
    
    private func takeActorTurns(for actors: [AIActor]) -> [ActorAnimation] {
        return actors.compactMap { actor in
            guard !actor.isDead else { return nil }
            let action = actor.turnAction()
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
    
    private func removeDeadActors() -> [ActorAnimation] {
        var deathAnimations = [ActorAnimation]()
        var deadActors = [Actor]()
        for actor in level.actors {
            guard let combatant = actor as? CombatantActor else { continue }
            if combatant.isDead {
                let deathAnimation = ActorAnimation(actor: combatant, animation: Animation.death)
                deathAnimations.append(deathAnimation)
                deadActors.append(combatant)
            }
        }
        level.actors = level.actors.filter { actor in
            !deadActors.contains { $0.spriteName == actor.spriteName }
        }
        return deathAnimations
    }
}

class DungeonLevel: LevelProviding {
    let map: GridMap
    let player: Actor
    var actors: [AIActor]
    var message: MessageLogging?
    
    init(map: GridMap, player: Actor, actors: [AIActor]) {
        self.map = map
        self.player = player
        self.actors = actors
        self.player.gameLevel = self
        for actor in actors {
            actor.gameLevel = self
        }
    }
}

class PlayerActor: CombatantActor {
}

typealias ActorAnimation = (actor: Actor, animation: Animation)
