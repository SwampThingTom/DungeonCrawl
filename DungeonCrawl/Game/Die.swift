//
//  Die.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/16/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol DieRolling {
    
    var sides: Int { get }
    
    /// Returns a random number between 1 and the number of sides on a die.
    func roll() -> Int
    
    /// Returns the sum of `numberOfDice` calls to `roll()`.
    func roll(numberOfDice: Int) -> Int
}

class Die: DieRolling, CustomStringConvertible {
    
    let sides: Int
    
    var description: String { return "d\(sides)" }

    private var randomNumberGenerator: AnyRandomNumberGenerator
    
    init(sides: Int, randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.sides = sides
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
    }
    
    func roll() -> Int {
        return roll(numberOfDice: 1)
    }
    
    func roll(numberOfDice: Int) -> Int {
        return (1...numberOfDice).reduce(0) { (sum, _) in
            sum + Int.random(in: 1 ... sides, using: &randomNumberGenerator)
        }
    }
}

class D100: Die {
    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        super.init(sides: 100, randomNumberGenerator: randomNumberGenerator)
    }
}

class D20: Die {
    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        super.init(sides: 20, randomNumberGenerator: randomNumberGenerator)
    }
}

class D12: Die {
    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        super.init(sides: 12, randomNumberGenerator: randomNumberGenerator)
    }
}

class D10: Die {
    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        super.init(sides: 10, randomNumberGenerator: randomNumberGenerator)
    }
}

class D8: Die {
    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        super.init(sides: 8, randomNumberGenerator: randomNumberGenerator)
    }
}

class D6: Die {
    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        super.init(sides: 6, randomNumberGenerator: randomNumberGenerator)
    }
}

class D4: Die {
    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        super.init(sides: 4, randomNumberGenerator: randomNumberGenerator)
    }
}

class D3: Die {
    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        super.init(sides: 3, randomNumberGenerator: randomNumberGenerator)
    }
}

class D2: Die {
    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        super.init(sides: 2, randomNumberGenerator: randomNumberGenerator)
    }
}
