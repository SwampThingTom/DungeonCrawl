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
        return Int.random(in: 1 ... sides, using: &randomNumberGenerator)
    }
}

class Dice: DieRolling {
    
    let die: DieRolling
    let numberOfDice: Int
    let modifier: Int
    
    var sides: Int {
        return die.sides
    }
    
    init(die: DieRolling, numberOfDice: Int = 1, modifier: Int = 0) {
        self.die = die
        self.numberOfDice = numberOfDice
        self.modifier = modifier
    }
    
    convenience init(die: DieRolling, plus modifier: Int) {
        guard let dice = die as? Dice else {
            self.init(die: die, modifier: modifier)
            return
        }
        self.init(die: dice, numberOfDice: dice.numberOfDice, modifier: dice.modifier + modifier)
    }
    
    func roll() -> Int {
        return modifier + (1...numberOfDice).reduce(0) { (sum, _) in
            sum + die.roll()
        }
    }
}

extension Dice: CustomStringConvertible {
    var description: String {
        let numberOfDiceDescription = numberOfDice > 1 ? "\(numberOfDice)" : ""
        return "\(numberOfDiceDescription)\(die)\(modifierDescription)"
    }
        
    private var modifierDescription: String {
        if self.modifier > 0 {
            return "+\(self.modifier)"
        }
        if self.modifier < 0 {
            return "\(self.modifier)"
        }
        return ""
    }
}

extension Dice: Equatable {
    static func == (lhs: Dice, rhs: Dice) -> Bool {
        return lhs.sides == rhs.sides
            && lhs.numberOfDice == rhs.numberOfDice
            && lhs.modifier == rhs.modifier
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
