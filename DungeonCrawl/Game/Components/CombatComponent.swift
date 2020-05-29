//
//  CombatComponent.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/17/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class CombatComponent: Component {
    
    var baseAttackBonus: Int
    var baseArmorClass: Int
    var baseDamageDie: DieRolling
    var maxHitPoints: Int
    
    var attackBonus: Int {
        return baseAttackBonus
    }
    
    var armorClass: Int {
        return baseArmorClass + equippedArmorBonus
    }
    
    private var equippedArmorBonus: Int {
        guard let items = entity?.inventoryComponent() else { return 0 }
        guard let armorBonus = items.equippedItem(for: .armor)?.item.armorBonus else { return 0 }
        return armorBonus
    }
    
    var weaponDamage: Int {
        let damageDice = equippedWeapon?.damageDice ?? baseDamageDie
        return damageDice.roll()
    }
    
    private var equippedWeapon: Item? {
        guard let items = entity?.inventoryComponent() else { return nil }
        return items.equippedItem(for: .weapon)?.item
    }
    
    var hitPoints: Int
    
    var isDead: Bool {
        return hitPoints <= 0
    }
    
    init(attackBonus: Int, armorClass: Int, damageDice: DieRolling, maxHitPoints: Int) {
        self.baseAttackBonus = attackBonus
        self.baseArmorClass = armorClass
        self.baseDamageDie = damageDice
        self.maxHitPoints = maxHitPoints
        self.hitPoints = maxHitPoints
    }
}

extension EntityManager {
    func combatComponent(for entity: Entity) -> CombatComponent? {
        return component(of: CombatComponent.self, for: entity) as? CombatComponent
    }
}

extension Entity {
    func combatComponent() -> CombatComponent? {
        return component(of: CombatComponent.self) as? CombatComponent
    }
}
