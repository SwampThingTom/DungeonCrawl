//
//  AnyRandomNumberGenerator.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 4/28/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

/// Allows injection of arbitrary `RandomNumberGenerator` implementations in system-provided
/// `<T>.random(using: RandomNumberGenerator)` methods.
///
/// - SeeAlso: https://stackoverflow.com/a/61287598/2348392
struct AnyRandomNumberGenerator: RandomNumberGenerator {
    
    private var generator: RandomNumberGenerator
    
    init(_ generator: RandomNumberGenerator) {
        self.generator = generator
    }
    
    mutating func next() -> UInt64 {
        return self.generator.next()
    }
    
    public mutating func next<T>() -> T where T: FixedWidthInteger, T: UnsignedInteger {
        return self.generator.next()
    }
    
    public mutating func next<T>(upperBound: T) -> T where T: FixedWidthInteger, T: UnsignedInteger {
        return self.generator.next(upperBound: upperBound)
    }
}
