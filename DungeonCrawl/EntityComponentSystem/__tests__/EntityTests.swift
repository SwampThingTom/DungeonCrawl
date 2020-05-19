//
//  EntityTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/18/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class EntityTests: XCTestCase {

    func testAddComponent() throws {
        // Arrange
        let entityManager = EntityManager()
        let expectedComponent = MockComponent1()
        let sut = entityManager.createEntity()
        
        // Act
        sut.add(component: expectedComponent)
        
        // Assert
        XCTAssertEqual(sut.component(of: MockComponent1.self) as? MockComponent1, expectedComponent)
        let componentFromEntityManager = entityManager.component(of: MockComponent1.self, for: sut) as? MockComponent1
        XCTAssertEqual(componentFromEntityManager, expectedComponent)
    }
    
    func testEntityManagerAddComponent() throws {
        // Arrange
        let entityManager = EntityManager()
        let expectedComponent = MockComponent1()
        let sut = entityManager.createEntity()
        entityManager.add(component: expectedComponent, to: sut)
        
        // Act
        let component = sut.component(of: MockComponent1.self)
        
        // Assert
        XCTAssertEqual(component as? MockComponent1, expectedComponent)
    }
}
