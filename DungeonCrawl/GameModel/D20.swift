//
//  D20.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/16/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol D20Providing {
    /// Returns a random number between 1 ... 20.
    func roll() -> Int
}

class D20: D20Providing {
    
    private var randomNumberGenerator: AnyRandomNumberGenerator
    
    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
    }

    func roll() -> Int {
        return Int.random(in: 1 ... 20, using: &randomNumberGenerator)
    }
}
