//
//  DungeonScene+Inventory.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/24/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import UIKit

extension DungeonScene: DismissibleViewControllerDelegate {
    
    func presentInventoryView() {
        guard let inventory = game.level.player.inventoryComponent() else { return }
        let inventoryViewController = InventoryViewController()
        inventoryViewController.inventory = inventoryViewModel(for: inventory)
        inventoryViewController.dismissingDelegate = self
        let viewController = UINavigationController(rootViewController: inventoryViewController)
        rootViewController?.present(viewController, animated: true)
    }
    
    func dismiss(viewController: UIViewController) {
        rootViewController?.dismiss(animated: true)
    }
}

func inventoryViewModel(for inventoryComponent: InventoryComponent) -> InventoryViewModel {
    let items: [InventoryViewModel.ItemViewModel] = inventoryComponent.items.map {
        let isEquipped = inventoryComponent.equippedItem(for: $0.equipmentSlot) != nil
        let description = isEquipped ? itemDescription($0) + " (equipped)" : itemDescription($0)
        return InventoryViewModel.ItemViewModel(name: description)
    }
    return InventoryViewModel(items: items)
}

private func itemDescription(_ item: Item) -> String {
    if let armor = item.armor {
        let baseArmorClass = 10 + armor.armorBonus
        return "Armor: \(item.name) (\(baseArmorClass))"
    }
    if let weapon = item.weapon {
        return "Weapon: \(item.name) (\(weapon.damageDie))"
    }
    return "Other: \(item.name)"
}
