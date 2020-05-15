//
//  DirectionGridPointTests.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 5/9/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

@testable import DungeonCrawl

import XCTest

class DirectionGridPointTests: XCTestCase {
    
    func testDirectionForAngle() throws {
        let pi_4 = CGFloat.pi / CGFloat(4.0)
        let tests = [
            (expected: Direction.east,
             minAngle: -pi_4,
             maxAngle: pi_4 - CGFloat(0.001)),
            (expected: Direction.south,
             minAngle: pi_4,
             maxAngle: pi_4 * CGFloat(3.0) - CGFloat(0.001)),
            (expected: Direction.west,
             minAngle: pi_4 * CGFloat(3.0),
             maxAngle: -pi_4 * CGFloat(3.0) - CGFloat(0.001)),
            (expected: Direction.north,
             minAngle: -pi_4 * CGFloat(3.0),
             maxAngle: -pi_4 - CGFloat(0.001)),
            (expected: nil,
             minAngle: -CGFloat.pi - CGFloat(0.001),
             maxAngle: CGFloat.pi + CGFloat(0.001))
        ]
        
        tests.forEach { (expected, minAngle, maxAngle) in
            XCTAssertEqual(Direction.direction(for: minAngle), expected)
            XCTAssertEqual(Direction.direction(for: maxAngle), expected)
        }
    }
    
    func testDirectionFromPointToPoint() throws {
        let origin = CGPoint(x: 0, y: 0)
        let tests = [
            (expected: Direction.east,
             from: origin,
             to: CGPoint(x: 120, y: 10)),
            (expected: Direction.north,
             from: origin,
             to: CGPoint(x: -10, y: -120)),
            (expected: Direction.west,
             from: origin,
             to: CGPoint(x: -120, y: 10)),
            (expected: Direction.south,
             from: origin,
             to: CGPoint(x: -10, y: 120))
        ]
        
        tests.forEach { (expected, from, to) in
            XCTAssertEqual(Direction.direction(from: from, to: to), expected)
        }
    }
}
