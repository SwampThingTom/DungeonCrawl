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
    
    var combatSystem: CombatProviding
    var enemyTurnActionSystem: EnemyTurnActionProviding
    var playerTurnActionSystem: PlayerTurnActionProviding
    var turnTakingSystem: TurnTaking
    
    var isPlayerDead: Bool {
        return level.player.combatComponent()?.isDead ?? true
    }
    
    var isQuestComplete: Bool {
        return level.quest.isComplete(gameLevel: level)
    }
    
    init(dungeonGenerator: DungeonGenerating,
         dungeonDecorator: DungeonDecorating,
         dungeonSize: GridSize,
         quest: QuestStatusProviding) {
        
        let dungeonModel = dungeonGenerator.generate(size: dungeonSize)
        let decorations = dungeonDecorator.decorate(dungeon: dungeonModel)
        
        entityManager = EntityManager()
        let entityFactory = EntityFactory(entityManager: entityManager)
        let playerEntity = entityFactory.createPlayer(cell: decorations.playerStartCell)
        let enemyEntities: [Entity] = decorations.enemies.map {
            entityFactory.createEnemy(enemyType: $0.enemyType, cell: $0.cell)
        }
        let objectEntities: [Entity] = decorations.objects.map {
            entityFactory.createObject(object: $0)
        }
        
        level = DungeonLevel(quest: quest,
                             map: dungeonModel.map,
                             rooms: dungeonModel.rooms,
                             player: playerEntity,
                             actors: enemyEntities,
                             objects: objectEntities)
        
        combatSystem = CombatSystem(entityManager: entityManager)
        enemyTurnActionSystem = EnemyTurnActionSystem(entityManager: entityManager, gameLevel: level)
        playerTurnActionSystem = PlayerTurnActionSystem(entityManager: entityManager, gameLevel: level)
        turnTakingSystem = TurnTakingSystem(entityManager: entityManager, gameLevel: level, combatSystem: combatSystem)
    }
    
    func takeTurn(playerAction: TurnAction) -> [SpriteAnimation] {
        let playerAnimation = takePlayerTurn(player: level.player, action: playerAction)
        let actorAnimations = takeActorTurns(for: level.actors)
        let deathAnimations = removeDeadActors()
        return combinedAnimations(playerAnimation: playerAnimation,
                                  actorAnimations: actorAnimations + deathAnimations)
    }
    
    private func takePlayerTurn(player: Entity, action: TurnAction) -> SpriteAnimation? {
        guard let playerSprite = player.spriteComponent() else { return nil }
        let playerTurnAnimation = turnTakingSystem.doTurnAction(action, for: player, actorSprite: playerSprite)
        return actorAnimation(actor: player, animation: playerTurnAnimation)
    }
    
    private func takeActorTurns(for actors: [Entity]) -> [SpriteAnimation] {
        return actors.compactMap { actor in
            guard let actorCombat = actor.combatComponent(), !actorCombat.isDead else { return nil }
            guard let actorEnemy = actor.enemyComponent() else { return nil }
            guard let actorSprite = actor.spriteComponent() else { return nil }
            let action = enemyTurnActionSystem.turnAction(for: actorEnemy, with: actorSprite)
            let animation = turnTakingSystem.doTurnAction(action, for: actor, actorSprite: actorSprite)
            return actorAnimation(actor: actor, animation: animation)
        }
    }
    
    private func actorAnimation(actor: Entity, animation: Animation?) -> SpriteAnimation? {
        guard let animation = animation else { return nil }
        guard let actorSprite = actor.spriteComponent() else { return nil }
        return SpriteAnimation(spriteName: actorSprite.spriteName, animation: animation)
    }
    
    private func combinedAnimations(playerAnimation: SpriteAnimation?,
                                    actorAnimations: [SpriteAnimation]) -> [SpriteAnimation] {
        if let playerAnimation = playerAnimation {
            return [playerAnimation] + actorAnimations
        }
        return actorAnimations
    }
    
    private func removeDeadActors() -> [SpriteAnimation] {
        var deathAnimations = [SpriteAnimation]()
        var deadActors = [Entity]()
        for actor in level.actors {
            guard let combatComponent = actor.combatComponent() else { continue }
            guard combatComponent.isDead else { continue }
            if let spriteComponent = actor.spriteComponent() {
                let deathAnimation = SpriteAnimation(spriteName: spriteComponent.spriteName, animation: Animation.death)
                deathAnimations.append(deathAnimation)
                deadActors.append(actor)
            }
        }
        level.actors = level.actors.filter { actor in
            guard let actorSprite = actor.spriteComponent() else { return false }
            return !deadActors.contains { deadActor in
                guard let deadActorSprite = deadActor.spriteComponent() else { return false }
                return deadActorSprite.spriteName == actorSprite.spriteName
            }
        }
        return deathAnimations
    }
}

class DungeonLevel: LevelProviding {
    let quest: QuestStatusProviding
    let map: GridMap
    let rooms: [RoomModel]
    let player: Entity
    var actors: [Entity]
    var objects: [Entity]
    var message: MessageLogging?
    
    init(quest: QuestStatusProviding,
         map: GridMap,
         rooms: [RoomModel],
         player: Entity,
         actors: [Entity],
         objects: [Entity]) {
        self.quest = quest
        self.map = map
        self.rooms = rooms
        self.player = player
        self.actors = actors
        self.objects = objects
    }
}

typealias SpriteAnimation = (spriteName: String, animation: Animation)
