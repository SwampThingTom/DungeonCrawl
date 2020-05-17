//
//  ActorTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/15/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class ActorTests: XCTestCase {

    func testDoTurnAction_move() throws {
        // Arrange
        let sut = TestActor(spriteName: "TestActor", cell: GridCell(x: 5, y: 5))
        
        // Act
        let animation = sut.doTurnAction(.move(to: GridCell(x: 4, y: 5), direction: .west))
        
        // Assert
        XCTAssertEqual(sut.cell, GridCell(x: 4, y: 5))
        XCTAssertEqual(animation, Animation.move(to: GridCell(x: 4, y: 5), heading: .west))
    }
    
    func testDoTurnAction_attack_hit() throws {
        // Arrange
        let mockCombat = MockCombat()
        mockCombat.mockAttackDamage = 3
        let target = TestAICombatant(spriteName: "Defender", cell: GridCell(x: 5, y: 4))
        let sut = CombatantActor(spriteName: "Attacker", displayName: "Attacker", cell: GridCell(x: 5, y: 5))
        sut.combat = mockCombat
        _ = MockGameLevel(player: sut, actors: [target])
        
        // Act
        let animation = sut.doTurnAction(.attack(direction: .north))
        
        // Assert
        XCTAssertEqual(animation, Animation.attack(heading: .north))
        XCTAssertEqual(target.mockDamageTaken, 3)
    }
    
    func testDoTurnAction_attack_miss() throws {
        // Arrange
        let mockCombat = MockCombat()
        mockCombat.mockAttackDamage = nil
        let target = TestAICombatant(spriteName: "Defender", cell: GridCell(x: 5, y: 4))
        let sut = CombatantActor(spriteName: "Attacker", displayName: "Attacker", cell: GridCell(x: 5, y: 5))
        sut.combat = mockCombat
        _ = MockGameLevel(player: sut, actors: [target])
        
        // Act
        let animation = sut.doTurnAction(.attack(direction: .north))
        
        // Assert
        XCTAssertEqual(animation, Animation.attack(heading: .north))
        XCTAssertNil(target.mockDamageTaken)
    }
    
    func testDoTurnAction_attack_playerTarget() throws {
        // Arrange
        let mockCombat = MockCombat()
        mockCombat.mockAttackDamage = 3
        let target = MockCombatantActor(spriteName: "Player", cell: GridCell(x: 5, y: 4))
        let sut = TestAICombatant(spriteName: "Attacker", cell: GridCell(x: 5, y: 5))
        sut.combat = mockCombat
        let level = MockGameLevel(player: target, actors: [sut])
        
        // Act
        let animation = sut.doTurnAction(.attack(direction: .north))
        
        // Assert
        XCTAssertEqual(animation, Animation.attack(heading: .north))
        XCTAssertEqual((level.player as? MockCombatantActor)!.mockDamageTaken, 3)
    }

    func testDoTurnAction_attack_attackerNotCombatant() throws {
        // Arrange
        let target = TestAICombatant(spriteName: "Defender", cell: GridCell(x: 5, y: 4))
        let sut = TestActor(spriteName: "Attacker", cell: GridCell(x: 5, y: 5))
        _ = MockGameLevel(player: sut, actors: [target])
        
        // Act
        let animation = sut.doTurnAction(.attack(direction: .north))
        
        // Assert
        XCTAssertNil(animation)
    }
    
    func testDoTurnAction_attack_noTarget() throws {
        // Arrange
        let mockCombat = MockCombat()
        mockCombat.mockAttackDamage = 3
        let target = TestAICombatant(spriteName: "Defender", cell: GridCell(x: 5, y: 4))
        let sut = CombatantActor(spriteName: "Attacker", displayName: "Attacker", cell: GridCell(x: 5, y: 5))
        sut.combat = mockCombat
        _ = MockGameLevel(player: sut, actors: [target])
        
        // Act
        let animation = sut.doTurnAction(.attack(direction: .south))
        
        // Assert
        XCTAssertNil(animation)
    }
    
    func testDoTurnAction_attack_targetNotCombatant() throws {
        // Arrange
        let mockCombat = MockCombat()
        mockCombat.mockAttackDamage = 3
        let target = TestAIActor(spriteName: "Defender", cell: GridCell(x: 5, y: 4))
        let sut = CombatantActor(spriteName: "Attacker", displayName: "Attacker", cell: GridCell(x: 5, y: 5))
        sut.combat = mockCombat
        _ = MockGameLevel(player: sut, actors: [target])
        
        // Act
        let animation = sut.doTurnAction(.attack(direction: .north))
        
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
    
    var mockDamageTaken: Int?
    
    override func takeDamage(_ damage: Int) {
        mockDamageTaken = damage
    }

    func turnAction() -> TurnAction {
        return .nothing
    }
}

class MockCombatantActor: CombatantActor {
    
    init(spriteName: String, cell: GridCell) {
        super.init(spriteName: spriteName, displayName: spriteName, cell: cell)
    }

    var mockDamageTaken: Int?
    
    override func takeDamage(_ damage: Int) {
        mockDamageTaken = damage
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
