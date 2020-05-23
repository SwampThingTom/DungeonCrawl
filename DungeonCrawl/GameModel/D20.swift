//
//  D20.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/16/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol DieRolling {
    /// Returns a random number between 1 and the number of sides on a die.
    func roll() -> Int
}

class Die: DieRolling {
    
    let sides: Int
    
    private var randomNumberGenerator: AnyRandomNumberGenerator
    
    init(sides: Int, randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.sides = sides
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
    }

    func roll() -> Int {
        return Int.random(in: 1 ... sides, using: &randomNumberGenerator)
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
