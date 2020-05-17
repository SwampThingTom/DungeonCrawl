//
//  FixedSizeQueueTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/16/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class FixedSizeQueueTests: XCTestCase {

    func testFixedSizeQueue_empty() throws {
        let sut = FixedSizeQueue<Int>(maxSize: 3)
        XCTAssertEqual(sut.count, 0)
        XCTAssertNil(sut.first)
        XCTAssertNil(sut.last)
    }
    
    func testFixedSizeQueue_firstItem() throws {
        var sut = FixedSizeQueue<Int>(maxSize: 3)
        sut.push(1)
        XCTAssertEqual(sut.count, 1)
        XCTAssertEqual(sut[0], 1)
        XCTAssertEqual(sut.first, 1)
        XCTAssertEqual(sut.last, 1)
    }
    
    func testFixedSizeQueue_maxItems() throws {
        var sut = FixedSizeQueue<Int>(maxSize: 3)
        sut.push(1)
        sut.push(2)
        sut.push(3)
        XCTAssertEqual(sut.count, 3)
        XCTAssertEqual(sut[0], 1)
        XCTAssertEqual(sut[1], 2)
        XCTAssertEqual(sut[2], 3)
        XCTAssertEqual(sut.first, 1)
        XCTAssertEqual(sut.last, 3)
    }
    
    func testFixedSizeQueue_overflow() throws {
        var sut = FixedSizeQueue<Int>(maxSize: 3)
        sut.push(1)
        sut.push(2)
        sut.push(3)
        sut.push(4)
        XCTAssertEqual(sut.count, 3)
        XCTAssertEqual(sut[0], 2)
        XCTAssertEqual(sut[1], 3)
        XCTAssertEqual(sut[2], 4)
        XCTAssertEqual(sut.first, 2)
        XCTAssertEqual(sut.last, 4)
    }
}
