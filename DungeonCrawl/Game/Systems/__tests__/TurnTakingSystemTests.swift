//
//  TurnTakingSystemTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/15/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class TurnTakingSystemTests: XCTestCase {
    
    var entityManager: EntityManager?
    var entityFactory: EntityFactory?
    
    override func setUp() {
        entityManager = EntityManager()
        entityFactory = EntityFactory(entityManager: entityManager!)
    }
    
    override func tearDown() {
        entityManager = nil
        entityFactory = nil
    }
    
    func testDoTurnAction_move() throws {
        // Arrange
        let actorSprite = mockSpriteComponent(spriteName: "TestActor", cell: GridCell(x: 5, y: 5))
        let actor = mockEntity(spriteComponent: actorSprite)
        let gameLevel = mockGameLevel(entityManager: entityManager!, player: actor)
        let sut = TurnTakingSystem(entityManager: entityManager!, gameLevel: gameLevel, combatSystem: MockCombat())
        let action = TurnAction.move(to: GridCell(x: 4, y: 5), direction: .west)
        
        // Act
        let animation = sut.doTurnAction(action, for: actor, actorSprite: actorSprite)
        
        // Assert
        XCTAssertEqual(animation, Animation.move(to: GridCell(x: 4, y: 5), heading: .west))
        XCTAssertEqual(actorSprite.cell, GridCell(x: 4, y: 5))
    }
    
    func testDoTurnAction_move_pickUpTreasure() throws {
        // Arrange
        let actorSprite = mockSpriteComponent(spriteName: "TestActor", cell: GridCell(x: 5, y: 5))
        let actor = mockEntity(spriteComponent: actorSprite)
        let actorInventory = mockInventoryComponent(gold: 10)
        actor.add(component: actorInventory)
        
        let treasure = mockItemEntity(item: createTreasure(worth: 50), cell: GridCell(x: 4, y: 5))
        let gameLevel = mockGameLevel(entityManager: entityManager!, player: actor)
        let sut = TurnTakingSystem(entityManager: entityManager!, gameLevel: gameLevel, combatSystem: MockCombat())
        let action = TurnAction.move(to: GridCell(x: 4, y: 5), direction: .west)
        
        // Act
        _ = sut.doTurnAction(action, for: actor, actorSprite: actorSprite)
        
        // Assert
        XCTAssertEqual(actorInventory.gold, 60)
        XCTAssertFalse(gameLevel.items.contains(treasure))
    }
    
    func testDoTurnAction_move_pickUpItem() throws {
        // Arrange
        let actorSprite = mockSpriteComponent(spriteName: "TestActor", cell: GridCell(x: 5, y: 5))
        let actor = mockEntity(spriteComponent: actorSprite)
        let actorInventory = mockInventoryComponent(gold: 10)
        actor.add(component: actorInventory)
        
        let shortSword = mockItemEntity(item: createShortSword(), cell: GridCell(x: 4, y: 5))
        let gameLevel = mockGameLevel(entityManager: entityManager!, player: actor)
        let sut = TurnTakingSystem(entityManager: entityManager!, gameLevel: gameLevel, combatSystem: MockCombat())
        let action = TurnAction.move(to: GridCell(x: 4, y: 5), direction: .west)
        
        // Act
        _ = sut.doTurnAction(action, for: actor, actorSprite: actorSprite)
        
        // Assert
        XCTAssert(actorInventory.items.contains(shortSword.itemComponent()!))
        XCTAssertNil(shortSword.spriteComponent())
        XCTAssertEqual(actorInventory.gold, 10)
    }
    
    func testDoTurnAction_attack_hit() throws {
        // Arrange
        let mockCombat = MockCombat()
        mockCombat.mockAttackDamage = 3
        
        let targetSprite = mockSpriteComponent(spriteName: "Defender", cell: GridCell(x: 5, y: 4))
        let targetCombat = mockCombatComponent()
        let targetEnemy = mockEnemyComponent()
        _ = mockEntity(spriteComponent: targetSprite,
                       combatComponent: targetCombat,
                       enemyComponent: targetEnemy)
        
        let actorSprite = mockSpriteComponent(spriteName: "Attacker", cell: GridCell(x: 5, y: 5))
        let actorCombat = mockCombatComponent()
        let actor = mockEntity(spriteComponent: actorSprite, combatComponent: actorCombat)
        
        let gameLevel = mockGameLevel(entityManager: entityManager!, player: actor)
        let sut = TurnTakingSystem(entityManager: entityManager!, gameLevel: gameLevel, combatSystem: mockCombat)
        
        // Act
        let animation = sut.doTurnAction(.attack(direction: .north), for: actor, actorSprite: actorSprite)
        
        // Assert
        XCTAssertEqual(animation, Animation.attack(heading: .north))
        XCTAssertEqual(targetCombat.hitPoints, 7)
    }
    
    func testDoTurnAction_attack_miss() throws {
        // Arrange
        let mockCombat = MockCombat()
        mockCombat.mockAttackDamage = nil
        
        let targetSprite = mockSpriteComponent(spriteName: "Defender", cell: GridCell(x: 5, y: 4))
        let targetCombat = mockCombatComponent()
        let targetEnemy = mockEnemyComponent()
        _ = mockEntity(spriteComponent: targetSprite,
                       combatComponent: targetCombat,
                       enemyComponent: targetEnemy)
        
        let actorSprite = mockSpriteComponent(spriteName: "Attacker", cell: GridCell(x: 5, y: 5))
        let actorCombat = mockCombatComponent()
        let actor = mockEntity(spriteComponent: actorSprite, combatComponent: actorCombat)
        
        let gameLevel = mockGameLevel(entityManager: entityManager!, player: actor)
        let sut = TurnTakingSystem(entityManager: entityManager!, gameLevel: gameLevel, combatSystem: mockCombat)
        
        // Act
        let animation = sut.doTurnAction(.attack(direction: .north), for: actor, actorSprite: actorSprite)
        
        // Assert
        XCTAssertEqual(animation, Animation.attack(heading: .north))
        XCTAssertEqual(targetCombat.hitPoints, 10)
    }
    
    func testDoTurnAction_attack_playerTarget() throws {
        // Arrange
        let mockCombat = MockCombat()
        mockCombat.mockAttackDamage = 3
        
        let targetSprite = mockSpriteComponent(spriteName: "Defender", cell: GridCell(x: 5, y: 4))
        let targetCombat = mockCombatComponent()
        let target = mockEntity(spriteComponent: targetSprite, combatComponent: targetCombat)
        
        let actorSprite = mockSpriteComponent(spriteName: "Attacker", cell: GridCell(x: 5, y: 5))
        let actorCombat = mockCombatComponent()
        let actorEnemy = mockEnemyComponent()
        let actor = mockEntity(spriteComponent: actorSprite, combatComponent: actorCombat, enemyComponent: actorEnemy)
        
        let gameLevel = mockGameLevel(entityManager: entityManager!, player: target)
        let sut = TurnTakingSystem(entityManager: entityManager!, gameLevel: gameLevel, combatSystem: mockCombat)
        
        // Act
        let animation = sut.doTurnAction(.attack(direction: .north), for: actor, actorSprite: actorSprite)
        
        // Assert
        XCTAssertEqual(animation, Animation.attack(heading: .north))
        let playerCombat = entityManager?.combatComponent(for: gameLevel.player)
        XCTAssertEqual(playerCombat!.hitPoints, 7)
    }
    
    func testDoTurnAction_attack_attackerNotCombatant() throws {
        // Arrange
        let targetSprite = mockSpriteComponent(spriteName: "Defender", cell: GridCell(x: 5, y: 4))
        let targetCombat = mockCombatComponent()
        let targetEnemy = mockEnemyComponent()
        _ = mockEntity(spriteComponent: targetSprite,
                       combatComponent: targetCombat,
                       enemyComponent: targetEnemy)
        
        let actorSprite = mockSpriteComponent(spriteName: "Attacker", cell: GridCell(x: 5, y: 5))
        let actor = mockEntity(spriteComponent: actorSprite)
        
        let gameLevel = mockGameLevel(entityManager: entityManager!, player: actor)
        let sut = TurnTakingSystem(entityManager: entityManager!, gameLevel: gameLevel, combatSystem: MockCombat())
        
        // Act
        let animation = sut.doTurnAction(.attack(direction: .north), for: actor, actorSprite: actorSprite)
        
        // Assert
        XCTAssertNil(animation)
    }
    
    func testDoTurnAction_attack_noTarget() throws {
        // Arrange
        let mockCombat = MockCombat()
        mockCombat.mockAttackDamage = 3
        
        let targetSprite = mockSpriteComponent(spriteName: "Defender", cell: GridCell(x: 5, y: 4))
        let targetCombat = mockCombatComponent()
        let targetEnemy = mockEnemyComponent()
        _ = mockEntity(spriteComponent: targetSprite,
                       combatComponent: targetCombat,
                       enemyComponent: targetEnemy)
        
        let actorSprite = mockSpriteComponent(spriteName: "Attacker", cell: GridCell(x: 5, y: 5))
        let actorCombat = mockCombatComponent()
        let actor = mockEntity(spriteComponent: actorSprite, combatComponent: actorCombat)
        
        let gameLevel = mockGameLevel(entityManager: entityManager!, player: actor)
        let sut = TurnTakingSystem(entityManager: entityManager!, gameLevel: gameLevel, combatSystem: mockCombat)
        
        // Act
        let animation = sut.doTurnAction(.attack(direction: .south), for: actor, actorSprite: actorSprite)
        
        // Assert
        XCTAssertNil(animation)
    }
    
    func testDoTurnAction_attack_targetNotCombatant() throws {
        // Arrange
        let mockCombat = MockCombat()
        mockCombat.mockAttackDamage = 3
        
        let targetSprite = mockSpriteComponent(spriteName: "Defender", cell: GridCell(x: 5, y: 4))
        let targetEnemy = mockEnemyComponent()
        _ = mockEntity(spriteComponent: targetSprite, enemyComponent: targetEnemy)
        
        let actorSprite = mockSpriteComponent(spriteName: "Attacker", cell: GridCell(x: 5, y: 5))
        let actorCombat = mockCombatComponent()
        let actor = mockEntity(spriteComponent: actorSprite, combatComponent: actorCombat)
        
        let gameLevel = mockGameLevel(entityManager: entityManager!, player: actor)
        let sut = TurnTakingSystem(entityManager: entityManager!, gameLevel: gameLevel, combatSystem: mockCombat)
        
        // Act
        let animation = sut.doTurnAction(.attack(direction: .north), for: actor, actorSprite: actorSprite)
        
        // Assert
        XCTAssertNil(animation)
    }
    
    func mockSpriteComponent(spriteName: String, cell: GridCell) -> SpriteComponent {
        return SpriteComponent(spriteName: spriteName, displayName: spriteName, cell: cell)
    }
    
    func mockCombatComponent() -> CombatComponent {
        let damageDie = MockDie(nextRoll: 3)
        return CombatComponent(attackBonus: 0, armorClass: 10, damageDie: damageDie, maxHitPoints: 10)
    }
    
    func mockEnemyComponent() -> EnemyComponent {
        return EnemyComponent(enemyType: .ghost)
    }
    
    func mockInventoryComponent(gold: Int) -> InventoryComponent {
        let inventory = InventoryComponent()
        inventory.gold += gold
        return inventory
    }
    
    func mockEntity(spriteComponent: SpriteComponent,
                    combatComponent: CombatComponent? = nil,
                    enemyComponent: EnemyComponent? = nil) -> Entity {
        let entity = entityManager!.createEntity()
        entityManager!.add(component: spriteComponent, to: entity)
        if let combatComponent = combatComponent {
            entityManager!.add(component: combatComponent, to: entity)
        }
        if let enemyComponent = enemyComponent {
            entityManager!.add(component: enemyComponent, to: entity)
        }
        return entity
    }
    
    func mockItemEntity(item: Item, cell: GridCell) -> Entity {
        let entity = entityManager!.createEntity()
        let spriteComponent = mockSpriteComponent(spriteName: "gold", cell: cell)
        entity.add(component: spriteComponent)
        let itemComponent = ItemComponent(item: item)
        entity.add(component: itemComponent)
        return entity
    }
}

func mockGameLevel(entityManager: EntityManager, player: Entity, rooms: [RoomModel] = []) -> DungeonLevel {
    return DungeonLevel(quest: MockQuest(),
                        map: fiveRegionMap(),
                        rooms: rooms,
                        entityManager: entityManager,
                        player: player)
}

class MockCombat: CombatProviding {
    
    var d20: DieRolling = D20()
    
    var mockAttackDamage: Int?
    
    func attack(attacker: CombatComponent, defender: CombatComponent) -> Int? {
        return mockAttackDamage
    }
}
