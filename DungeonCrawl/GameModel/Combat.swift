//
//  CombatProviding.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/15/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol D20Providing {
    /// Returns a random number between 1 ... 20.
    func roll() -> Int
}

protocol Combatant {
    var attackBonus: Int { get }
    var armorClass: Int { get }
    func damage() -> Int
}

protocol CombatProviding {
    var d20: D20Providing { get set }
    func attack(attacker: Combatant, defender: Combatant) -> Int?
}

/// Determines combat results based on a simplified D20 system.
///
/// - SeeAlso: https://www.d20pfsrd.com/Gamemastering/Combat/#TOC-Damage
/// - SeeAlso: http://www.easydamus.com/BasicD20.pdf
struct Combat: CombatProviding {
    
    var d20: D20Providing
    
    func attack(attacker: Combatant, defender: Combatant) -> Int? {
        let attackRoll = d20.roll() + attacker.attackBonus
        if attackRoll >= defender.armorClass {
            return attacker.damage()
        }
        return nil
    }
}
