//
//  CombatProviding.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/15/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol CombatProviding {
    func attack(attacker: Actor, defender: Actor) -> Int
}

struct Combat: CombatProviding {
    
    func attack(attacker: Actor, defender: Actor) -> Int {
        return 1
    }
}
