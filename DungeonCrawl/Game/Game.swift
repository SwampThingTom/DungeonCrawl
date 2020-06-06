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
    var enemyControllerSystem: EnemyControlling
    var potionSystem: PotionUsing
    var playerControllerSystem: PlayerControlling
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
        let decorations = dungeonDecorator.decorate(dungeon: dungeonModel, questItem: quest.item)
        
        entityManager = EntityManager()
        let entityFactory = EntityFactory(entityManager: entityManager)
        let playerEntity = entityFactory.createPlayer(cell: decorations.playerStartCell)
        decorations.enemies.forEach {
            entityFactory.createEnemy(enemyType: $0.enemyType, cell: $0.cell)
        }
        decorations.items.forEach {
            entityFactory.createItem($0)
        }
        
        level = DungeonLevel(quest: quest,
                             map: dungeonModel.map,
                             rooms: dungeonModel.rooms,
                             entityManager: entityManager,
                             player: playerEntity)
        
        combatSystem = CombatSystem(entityManager: entityManager)
        enemyControllerSystem = EnemyControllerSystem(entityManager: entityManager, gameLevel: level)
        playerControllerSystem = PlayerControllerSystem(entityManager: entityManager, gameLevel: level)
        potionSystem = PotionSystem(entityManager: entityManager)
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
            let action = enemyControllerSystem.turnAction(for: actorEnemy, with: actorSprite)
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
        for actor in level.actors {
            guard let combatComponent = actor.combatComponent() else { continue }
            guard combatComponent.isDead else { continue }
            if let spriteComponent = actor.spriteComponent() {
                let deathAnimation = SpriteAnimation(spriteName: spriteComponent.spriteName, animation: Animation.death)
                deathAnimations.append(deathAnimation)
            }
            level.entityManager.remove(entity: actor)
        }
        return deathAnimations
    }
}

typealias SpriteAnimation = (spriteName: String, animation: Animation)
