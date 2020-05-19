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
        let gameLevel = MockGameLevel(player: actor, actors: [])
        let sut = TurnTakingSystem(entityManager: entityManager!, gameLevel: gameLevel, combatSystem: MockCombat())
        
        // Act
        let action = TurnAction.move(to: GridCell(x: 4, y: 5), direction: .west)
        let animation = sut.doTurnAction(action, for: actor, actorSprite: actorSprite)
        
        // Assert
        XCTAssertEqual(animation, Animation.move(to: GridCell(x: 4, y: 5), heading: .west))
        XCTAssertEqual(actorSprite.cell, GridCell(x: 4, y: 5))
    }
    
    func testDoTurnAction_attack_hit() throws {
        // Arrange
        let mockCombat = MockCombat()
        mockCombat.mockAttackDamage = 3
        
        let targetSprite = mockSpriteComponent(spriteName: "Defender", cell: GridCell(x: 5, y: 4))
        let targetCombat = mockCombatComponent()
        let targetEnemy = mockEnemyComponent()
        let target = mockEntity(spriteComponent: targetSprite,
                                combatComponent: targetCombat,
                                enemyComponent: targetEnemy)
        
        let actorSprite = mockSpriteComponent(spriteName: "Attacker", cell: GridCell(x: 5, y: 5))
        let actorCombat = mockCombatComponent()
        let actor = mockEntity(spriteComponent: actorSprite, combatComponent: actorCombat)

        let gameLevel = MockGameLevel(player: actor, actors: [target])
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
        let target = mockEntity(spriteComponent: targetSprite,
                                combatComponent: targetCombat,
                                enemyComponent: targetEnemy)
        
        let actorSprite = mockSpriteComponent(spriteName: "Attacker", cell: GridCell(x: 5, y: 5))
        let actorCombat = mockCombatComponent()
        let actor = mockEntity(spriteComponent: actorSprite, combatComponent: actorCombat)

        let gameLevel = MockGameLevel(player: actor, actors: [target])
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

        let gameLevel = MockGameLevel(player: target, actors: [actor])
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
        let target = mockEntity(spriteComponent: targetSprite,
                                combatComponent: targetCombat,
                                enemyComponent: targetEnemy)
        
        let actorSprite = mockSpriteComponent(spriteName: "Attacker", cell: GridCell(x: 5, y: 5))
        let actor = mockEntity(spriteComponent: actorSprite)

        let gameLevel = MockGameLevel(player: actor, actors: [target])
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
        let target = mockEntity(spriteComponent: targetSprite,
                                combatComponent: targetCombat,
                                enemyComponent: targetEnemy)

        let actorSprite = mockSpriteComponent(spriteName: "Attacker", cell: GridCell(x: 5, y: 5))
        let actorCombat = mockCombatComponent()
        let actor = mockEntity(spriteComponent: actorSprite, combatComponent: actorCombat)

        let gameLevel = MockGameLevel(player: actor, actors: [target])
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
        let target = mockEntity(spriteComponent: targetSprite, enemyComponent: targetEnemy)
        
        let actorSprite = mockSpriteComponent(spriteName: "Attacker", cell: GridCell(x: 5, y: 5))
        let actorCombat = mockCombatComponent()
        let actor = mockEntity(spriteComponent: actorSprite, combatComponent: actorCombat)
        
        let gameLevel = MockGameLevel(player: actor, actors: [target])
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
        return CombatComponent(attackBonus: 0, armorClass: 10, hitPoints: 10, weaponDamage: 3)
    }
    
    func mockEnemyComponent() -> EnemyComponent {
        return EnemyComponent(enemyType: .ghost)
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
}

struct MockGameLevel: LevelProviding {
    var quest: QuestStatusProviding = MockQuest()
    var map: GridMap = fiveRegionMap()
    var player: Entity
    var actors: [Entity]
    var message: MessageLogging?
    
    init(player: Entity, actors: [Entity]) {
        self.player = player
        self.actors = actors
    }
}

class MockCombat: CombatProviding {
    
    var d20: D20Providing = D20()
    
    var mockAttackDamage: Int?
    
    func attack(attacker: CombatComponent, defender: CombatComponent) -> Int? {
        return mockAttackDamage
    }
}

/// Returns a 17x15 map with five regions.
///
///    `                      1111111`
///    `01234567890123456`
/// 00: `*****************`
/// 01: `*_*___*___*_____*`
/// 02: `*_*_*_*___*_*_*_*`
/// 03: `*___*_$___*_*_*_*`
/// 04: `***_*_*___*_***_*`
/// 05: `*_*_*_*___*___*_*`
/// 06: `*_*_***___*_***$*`
/// 07: `*_____*___*_*___*`
/// 08: `***$*******_*___*`
/// 09: `*_______*_*_*___*`
/// 10: `*_______*_*_*****`
/// 11: `*_______*_*_____*`
/// 12: `***$*****_*****_*`
/// 13: `*_______________*`
/// 14: `*****************`
private func fiveRegionMap() -> MutableGridMap {

    let tiles = [
        "_*___*___*_____",
        "_*_*_*___*_*_*_",
        "___*_$___*_*_*_",
        "**_*_*___*_***_",
        "_*_*_*___*___*_",
        "_*_***___*_***$",
        "_____*___*_*___",
        "**$*******_*___",
        "_______*_*_*___",
        "_______*_*_****",
        "_______*_*_____",
        "**$*****_*****_",
        "_______________"
    ]
    
    let mapBuilder = MockMapBuilder(size: GridSize(width: 17, height: 15))
    mapBuilder.addTiles(origin: GridCell(x: 1, y: 1), description: tiles)
    return mapBuilder.build()
}

private class MockMapBuilder {
    
    private var map: DungeonMap
    
    init(size: GridSize) {
        self.map = DungeonMap(size: size)
    }
    
    func addTiles(origin: GridCell, description gridStrings: [String]) {
        for y in 0 ..< gridStrings.count {
            let gridString = gridStrings[y]
            var x = 0
            for index in gridString.indices {
                if gridString[index] == "_" {
                    let cell = GridCell(x: origin.x + x, y: origin.y + y)
                    map.setTile(at: cell, tile: .floor)
                }
                if gridString[index] == "$" {
                    let cell = GridCell(x: origin.x + x, y: origin.y + y)
                    map.setTile(at: cell, tile: .door)
                }
                x += 1
            }
        }
    }
    
    func build() -> DungeonMap {
        return map
    }
}
