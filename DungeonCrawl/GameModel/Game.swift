//
//  Game.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/14/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class Game {
    
    var entityManager: EntityManager
    var level: DungeonLevel
    var combatSystem: CombatSystem
    var turnSystem: TurnSystem
    var aiSystem: EnemySystem
    
    init(dungeonGenerator: DungeonGenerating,
         dungeonDecorator: DungeonDecorating,
         dungeonSize: GridSize) {
        
        let dungeonModel = dungeonGenerator.generate(size: dungeonSize)
        let decorations = dungeonDecorator.decorate(dungeon: dungeonModel)
        
        entityManager = EntityManager()
        let entityFactory = EntityFactory(entityManager: entityManager)
        let playerEntity = entityFactory.createPlayer(cell: decorations.playerStartCell)
        let enemyEntities: [Entity] = decorations.enemies.map {
            entityFactory.createEnemy(enemyType: $0.enemyType, cell: $0.cell)
        }
        
        level = DungeonLevel(map: dungeonModel.map,
                             player: playerEntity,
                             actors: enemyEntities)
        
        combatSystem = CombatSystem(entityManager: entityManager)
        turnSystem = TurnSystem(entityManager: entityManager, gameLevel: level, combatSystem: combatSystem)
        aiSystem = EnemySystem(entityManager: entityManager, gameLevel: level)
    }
    
    func takeTurn(playerAction: TurnAction) -> [ActorAnimation] {
        let playerAnimation = takePlayerTurn(player: level.player, action: playerAction)
        let actorAnimations = takeActorTurns(for: level.actors)
        let deathAnimations = removeDeadActors()
        return combinedAnimations(playerAnimation: playerAnimation,
                                  actorAnimations: actorAnimations + deathAnimations)
    }
    
    private func takePlayerTurn(player: Entity, action: TurnAction) -> ActorAnimation? {
        let playerTurnAnimation = turnSystem.doTurnAction(action, for: player)
        return actorAnimation(actor: level.player, animation: playerTurnAnimation)
    }
    
    private func takeActorTurns(for actors: [Entity]) -> [ActorAnimation] {
        return actors.compactMap { actor in
            guard let combatComponent = entityManager.combatComponent(for: actor) else { return nil }
            guard !combatComponent.isDead else { return nil }
            let action = aiSystem.turnAction(for: actor)
            let animation = turnSystem.doTurnAction(action, for: actor)
            return actorAnimation(actor: actor, animation: animation)
        }
    }
    
    private func actorAnimation(actor: Entity, animation: Animation?) -> ActorAnimation? {
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
        var deadActors = [Entity]()
        for actor in level.actors {
            guard let combatComponent = entityManager.combatComponent(for: actor) else { continue }
            if combatComponent.isDead {
                let deathAnimation = ActorAnimation(actor: actor, animation: Animation.death)
                deathAnimations.append(deathAnimation)
                deadActors.append(actor)
            }
        }
        level.actors = level.actors.filter { actor in
            guard let actorSprite = entityManager.spriteComponent(for: actor) else { return false }
            return !deadActors.contains { deadActor in
                guard let deadActorSprite = entityManager.spriteComponent(for: deadActor) else { return false }
                return deadActorSprite.spriteName == actorSprite.spriteName
            }
        }
        return deathAnimations
    }
}

class DungeonLevel: LevelProviding {
    let map: GridMap
    let player: Entity
    var actors: [Entity]
    var message: MessageLogging?
    
    init(map: GridMap, player: Entity, actors: [Entity]) {
        self.map = map
        self.player = player
        self.actors = actors
    }
}

typealias ActorAnimation = (actor: Entity, animation: Animation)
