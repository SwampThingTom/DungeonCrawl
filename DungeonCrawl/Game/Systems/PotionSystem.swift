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
    /// - Parameter potionItem: The item component for the potion.
    /// - Parameter target: The potion's target.
    /// - Parameter inventory: The inventory containing the potion, or `nil` if not in an inventory.
    func use(potionItem: ItemComponent, on target: Entity, from inventory: InventoryComponent?)
}

/// Manages the use of potions.
class PotionSystem: System, PotionUsing {
    
    override init(entityManager: EntityManager) {
        super.init(entityManager: entityManager)
    }
    
    func use(potionItem: ItemComponent, on target: Entity, from inventory: InventoryComponent? = nil) {
        guard let potion = potionItem.item.potion else { fatalError("Can only use a potion") }
        switch potion {
        case .heal:
            applyHeal(to: target)
        case .armorBonus:
            enchantArmor(for: target)
        case .damageBonus:
            enchantWeapon(for: target)
        }
        inventory?.remove(item: potionItem)
    }
    
    private func applyHeal(to target: Entity) {
        guard let combatComponent = target.combatComponent() else { return }
        let restoredHealth = D8().roll()
        combatComponent.heal(damage: restoredHealth)
    }
    
    private func enchantArmor(for target: Entity) {
        guard let inventory = target.inventoryComponent() else { return }
        guard let equippedArmor = inventory.equippedItem(for: .armor) else { return }
        equippedArmor.enchant(armorBonus: 1)
    }
    
    private func enchantWeapon(for target: Entity) {
        guard let inventory = target.inventoryComponent() else { return }
        guard let equippedArmor = inventory.equippedItem(for: .weapon) else { return }
        equippedArmor.enchant(damageBonus: 1)
    }
}
