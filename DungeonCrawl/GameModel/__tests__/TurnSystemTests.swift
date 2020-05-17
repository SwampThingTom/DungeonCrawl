//
//  TurnSystemTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/15/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class TurnSystemTests: XCTestCase {

    func testDoTurnAction_move() throws {
        // Arrange
        let actor = TestActor(spriteName: "TestActor", cell: GridCell(x: 5, y: 5))
        let gameLevel = MockGameLevel(player: actor, actors: [])
        let sut = TurnSystem(gameLevel: gameLevel, combatSystem: MockCombat())
        
        // Act
        let animation = sut.doTurnAction(.move(to: GridCell(x: 4, y: 5), direction: .west), for: actor)
        
        // Assert
        XCTAssertEqual(animation, Animation.move(to: GridCell(x: 4, y: 5), heading: .west))
        XCTAssertEqual(actor.cell, GridCell(x: 4, y: 5))
    }
    
    func testDoTurnAction_attack_hit() throws {
        // Arrange
        let mockCombat = MockCombat()
        mockCombat.mockAttackDamage = 3
        let target = TestAICombatant(spriteName: "Defender", cell: GridCell(x: 5, y: 4))
        target.hitPoints = 10
        let actor = CombatantActor(spriteName: "Attacker", displayName: "Attacker", cell: GridCell(x: 5, y: 5))
        let gameLevel = MockGameLevel(player: actor, actors: [target])
        let sut = TurnSystem(gameLevel: gameLevel, combatSystem: mockCombat)
        
        // Act
        let animation = sut.doTurnAction(.attack(direction: .north), for: actor)
        
        // Assert
        XCTAssertEqual(animation, Animation.attack(heading: .north))
        XCTAssertEqual(target.hitPoints, 7)
    }
    
    func testDoTurnAction_attack_miss() throws {
        // Arrange
        let mockCombat = MockCombat()
        mockCombat.mockAttackDamage = nil
        let target = TestAICombatant(spriteName: "Defender", cell: GridCell(x: 5, y: 4))
        target.hitPoints = 10
        let actor = CombatantActor(spriteName: "Attacker", displayName: "Attacker", cell: GridCell(x: 5, y: 5))
        let gameLevel = MockGameLevel(player: actor, actors: [target])
        let sut = TurnSystem(gameLevel: gameLevel, combatSystem: mockCombat)

        // Act
        let animation = sut.doTurnAction(.attack(direction: .north), for: actor)
        
        // Assert
        XCTAssertEqual(animation, Animation.attack(heading: .north))
        XCTAssertEqual(target.hitPoints, 10)
    }
    
    func testDoTurnAction_attack_playerTarget() throws {
        // Arrange
        let mockCombat = MockCombat()
        mockCombat.mockAttackDamage = 3
        let target = MockCombatantActor(spriteName: "Player", cell: GridCell(x: 5, y: 4))
        target.hitPoints = 10
        let actor = TestAICombatant(spriteName: "Attacker", cell: GridCell(x: 5, y: 5))
        let gameLevel = MockGameLevel(player: target, actors: [actor])
        let sut = TurnSystem(gameLevel: gameLevel, combatSystem: mockCombat)

        // Act
        let animation = sut.doTurnAction(.attack(direction: .north), for: actor)
        
        // Assert
        XCTAssertEqual(animation, Animation.attack(heading: .north))
        XCTAssertEqual((gameLevel.player as? MockCombatantActor)!.hitPoints, 7)
    }

    func testDoTurnAction_attack_attackerNotCombatant() throws {
        // Arrange
        let target = TestAICombatant(spriteName: "Defender", cell: GridCell(x: 5, y: 4))
        let actor = TestActor(spriteName: "Attacker", cell: GridCell(x: 5, y: 5))
        let gameLevel = MockGameLevel(player: actor, actors: [target])
        let sut = TurnSystem(gameLevel: gameLevel, combatSystem: MockCombat())

        // Act
        let animation = sut.doTurnAction(.attack(direction: .north), for: actor)
        
        // Assert
        XCTAssertNil(animation)
    }
    
    func testDoTurnAction_attack_noTarget() throws {
        // Arrange
        let mockCombat = MockCombat()
        mockCombat.mockAttackDamage = 3
        let target = TestAICombatant(spriteName: "Defender", cell: GridCell(x: 5, y: 4))
        let actor = CombatantActor(spriteName: "Attacker", displayName: "Attacker", cell: GridCell(x: 5, y: 5))
        let gameLevel = MockGameLevel(player: actor, actors: [target])
        let sut = TurnSystem(gameLevel: gameLevel, combatSystem: mockCombat)
        
        // Act
        let animation = sut.doTurnAction(.attack(direction: .south), for: actor)
        
        // Assert
        XCTAssertNil(animation)
    }
    
    func testDoTurnAction_attack_targetNotCombatant() throws {
        // Arrange
        let mockCombat = MockCombat()
        mockCombat.mockAttackDamage = 3
        let target = TestAIActor(spriteName: "Defender", cell: GridCell(x: 5, y: 4))
        let actor = CombatantActor(spriteName: "Attacker", displayName: "Attacker", cell: GridCell(x: 5, y: 5))
        let gameLevel = MockGameLevel(player: actor, actors: [target])
        let sut = TurnSystem(gameLevel: gameLevel, combatSystem: mockCombat)

        // Act
        let animation = sut.doTurnAction(.attack(direction: .north), for: actor)
        
        // Assert
        XCTAssertNil(animation)
    }
}

class TestActor: Actor {
    var spriteName: String
    var displayName: String
    var cell: GridCell
    var isDead: Bool = false
    var gameLevel: LevelProviding?

    init(spriteName: String, cell: GridCell) {
        self.spriteName = spriteName
        self.displayName = spriteName
        self.cell = cell
    }
}

class TestAIActor: AIActor {
    var spriteName: String
    var displayName: String
    var cell: GridCell
    var isDead: Bool = false
    var gameLevel: LevelProviding?
    var enemyType: EnemyType = .ghost
    
    init(spriteName: String, cell: GridCell) {
        self.spriteName = spriteName
        self.displayName = spriteName
        self.cell = cell
    }
    
    func turnAction() -> TurnAction {
        return .nothing
    }
}

class TestAICombatant: CombatantActor, AIActor {
    var enemyType: EnemyType = .ghost
    
    init(spriteName: String, cell: GridCell) {
        super.init(spriteName: spriteName, displayName: spriteName, cell: cell)
    }
}

class MockCombatantActor: CombatantActor {
    
    init(spriteName: String, cell: GridCell) {
        super.init(spriteName: spriteName, displayName: spriteName, cell: cell)
    }
}

struct MockGameLevel: LevelProviding {
    var map: GridMap = DungeonMap()
    var player: Actor
    var actors: [AIActor]
    var message: MessageLogging?
    
    init(player: Actor, actors: [AIActor]) {
        self.player = player
        self.actors = actors
        self.player.gameLevel = self
        for actor in self.actors {
            actor.gameLevel = self
        }
    }
}

class MockCombat: CombatProviding {
    
    var d20: D20Providing = D20()
    
    var mockAttackDamage: Int?
    
    func attack(attacker: Combatant, defender: Combatant) -> Int? {
        return mockAttackDamage
    }
}
