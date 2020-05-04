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
        let msw = UInt32(bitPattern: Int32(source.nextInt()))
        let lsw = UInt32(bitPattern: Int32(source.nextInt()))
        return UInt64(msw) << 32 | UInt64(lsw)
    }
    
    public mutating func next<T>() -> T where T : FixedWidthInteger, T : UnsignedInteger {
        return T(next())
    }
    
    public mutating func next<T>(upperBound: T) -> T where T : FixedWidthInteger, T : UnsignedInteger {
        return T(next())
    }
}
