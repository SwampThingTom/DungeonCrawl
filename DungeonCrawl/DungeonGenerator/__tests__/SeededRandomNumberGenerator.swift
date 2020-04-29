//
//  SeededRandomNumberGenerator.swift
//  DungeonCrawlTests
//
//  Created by Thomas Aylesworth on 4/28/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation
import GameKit

struct SeededRandomNumberGenerator: RandomNumberGenerator {
    
    private let source: GKARC4RandomSource
    
    init(seed: Data) {
        source = GKARC4RandomSource(seed: seed)
    }
    
    mutating func next() -> UInt64 {
        let msw: UInt64 = UInt64(clamping: source.nextInt())
        let lsw: UInt64 = UInt64(clamping: source.nextInt())
        return msw << 64 | lsw
    }
    
    public mutating func next<T>() -> T where T : FixedWidthInteger, T : UnsignedInteger {
        return T(next())
    }
    
    public mutating func next<T>(upperBound: T) -> T where T : FixedWidthInteger, T : UnsignedInteger {
        return T(next())
    }
}
