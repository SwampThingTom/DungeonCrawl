//
//  PotionSystem.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/29/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol PotionUsing {
    
    /// Applies the effect of a potion to a target.
    func use(potion: PotionType, on target: Entity)
}

/// Manages the use of potions.
class PotionSystem: System, PotionUsing {
    
    override init(entityManager: EntityManager) {
        super.init(entityManager: entityManager)
    }
    
    func use(potion: PotionType, on target: Entity) {
        switch potion {
        case .heal:
            applyHeal(to: target)
        case .armorBonus:
            enchantArmor(for: target)
        case .attackBonus:
            enchantWeapon(for: target)
        }
    }
    
    private func applyHeal(to target: Entity) {
        guard let combatComponent = target.combatComponent() else { return }
        let restoredHealth = D8().roll()
        combatComponent.heal(damage: restoredHealth)
    }
    
    private func enchantArmor(for target: Entity) {
        // LATER: Enchant armor
    }
    
    private func enchantWeapon(for target: Entity) {
        // LATER: Enchant weapon
    }
}
