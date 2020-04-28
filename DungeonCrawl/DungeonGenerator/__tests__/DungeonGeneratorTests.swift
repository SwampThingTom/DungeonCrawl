//
//  DungeonGeneratorTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 4/27/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class DungeonGeneratorTests: XCTestCase {

    func testGenerate() {
        let sut = DungeonGenerator()
        let _ = sut.generate()
        XCTAssert(true)
    }

}
