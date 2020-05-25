//
//  EntityManagerTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/17/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class EntityManagerTests: XCTestCase {

    func testCreateEntity() throws {
        // Arrange
        let sut = EntityManager()
        
        // Act
        let entity1 = sut.createEntity()
        let entity2 = sut.createEntity()
        
        // Assert
        XCTAssertNotEqual(entity1.entityId, entity2.entityId)
    }
    
    func testAddComponent() throws {
        // Arrange
        let sut = EntityManager()
        let entity = sut.createEntity()
        let expectedComponent = MockComponent1()

        // Act
        sut.add(component: expectedComponent, to: entity)
        
        // Assert
        let component = sut.component(of: MockComponent1.self, for: entity) as? MockComponent1
        XCTAssertEqual(component, expectedComponent)
        XCTAssertEqual(component?.entity, entity)
        
        let components = sut.components(of: MockComponent1.self)
        XCTAssert(components.contains(expectedComponent))
    }
    
    func testAddComponent_multipleComponents() throws {
        // Arrange
        let sut = EntityManager()
        let entity = sut.createEntity()
        let expectedComponent1 = MockComponent1()
        let expectedComponent2 = MockComponent2()
        
        // Act
        sut.add(component: expectedComponent1, to: entity)
        sut.add(component: expectedComponent2, to: entity)
        
        // Assert
        let component1 = sut.component(of: MockComponent1.self, for: entity) as? MockComponent1
        XCTAssertEqual(component1, expectedComponent1)
        let component2 = sut.component(of: MockComponent2.self, for: entity) as? MockComponent2
        XCTAssertEqual(component2, expectedComponent2)
        
        let components1 = sut.components(of: MockComponent1.self)
        XCTAssertEqual(components1.count, 1)
        XCTAssert(components1.contains(expectedComponent1))
        
        let components2 = sut.components(of: MockComponent2.self)
        XCTAssertEqual(components2.count, 1)
        XCTAssert(components2.contains(expectedComponent2))
    }
    
    func testComponent_none() throws {
        // Arrange
        let sut = EntityManager()
        let entity = sut.createEntity()
        
        // Act
        let component = sut.component(of: MockComponent1.self, for: entity)
        
        // Assert
        XCTAssertNil(component)
    }
    
    func testComponents_none() throws {
        // Arrange
        let sut = EntityManager()
        
        // Act
        let components = sut.components(of: MockComponent1.self)
        
        // Assert
        XCTAssert(components.isEmpty)
    }

    func testEntitiesWithComponent() throws {
        // Arrange
        let sut = EntityManager()
        let entity1 = sut.createEntity()
        let entity2 = sut.createEntity()
        let expectedComponent1Entity1 = MockComponent1()
        let expectedComponent2Entity1 = MockComponent2()
        let expectedComponent1Entity2 = MockComponent1()
        sut.add(component: expectedComponent1Entity1, to: entity1)
        sut.add(component: expectedComponent2Entity1, to: entity1)
        sut.add(component: expectedComponent1Entity2, to: entity2)

        // Act
        let entitiesWithComponent1 = sut.entities(with: MockComponent1.self)
        let entitiesWithComponent2 = sut.entities(with: MockComponent2.self)
        
        // Assert
        XCTAssert(entitiesWithComponent1.contains(entity1))
        XCTAssert(entitiesWithComponent1.contains(entity2))
        XCTAssertEqual(entitiesWithComponent2, [entity1])
    }
    
    func testRemoveEntity() throws {
        // Arrange
        let sut = EntityManager()
        let entity1 = sut.createEntity()
        let entity2 = sut.createEntity()
        let expectedComponent1Entity1 = MockComponent1()
        let expectedComponent2Entity1 = MockComponent2()
        let expectedComponent1Entity2 = MockComponent1()
        sut.add(component: expectedComponent1Entity1, to: entity1)
        sut.add(component: expectedComponent2Entity1, to: entity1)
        sut.add(component: expectedComponent1Entity2, to: entity2)

        // Act
        sut.remove(entity: entity1)
        
        // Assert
        let entitiesWithComponent1 = sut.entities(with: MockComponent1.self)
        let entitiesWithComponent2 = sut.entities(with: MockComponent2.self)
        XCTAssert(!entitiesWithComponent1.contains(entity1))
        XCTAssert(entitiesWithComponent1.contains(entity2))
        XCTAssertEqual(entitiesWithComponent2.count, 0)
    }
}

class MockComponent1: Component {
    
    static var nextComponentID: Int = 0
    
    let componentID: Int
    
    override init() {
        componentID = MockComponent1.nextComponentID
        MockComponent1.nextComponentID += 1
    }
}

class MockComponent2: Component {
    
    static var nextComponentID: Int = 0
    
    let componentID: Int
    
    override init() {
        componentID = MockComponent2.nextComponentID
        MockComponent2.nextComponentID += 1
    }
}
