//
//  Chance.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/22/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol ChanceDetermining {
    
    /// Determines whether an event happened based on a one in X chance.
    ///
    /// - Parameter chance: The denominator for the chance the event will happen.
    /// A higher value indicates a lower chance.
    ///
    /// - Returns: `true` if the event happened
    func one(in chance: Int) -> Bool
}

class Chance: ChanceDetermining {
    
    private var randomNumberGenerator: AnyRandomNumberGenerator
    
    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
    }
    
    func one(in chance: Int) -> Bool {
        return Int.random(in: 1...chance, using: &randomNumberGenerator) == 1
    }
}
