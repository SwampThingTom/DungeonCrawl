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
        inventoryViewController.inventory = inventoryViewModel(for: inventory, equipHandler: toggleEquip(itemID:))
        inventoryViewController.dismissingDelegate = self
        let viewController = UINavigationController(rootViewController: inventoryViewController)
        rootViewController?.present(viewController, animated: true)
    }
    
    func dismiss(viewController: UIViewController) {
        rootViewController?.dismiss(animated: true)
    }
    
    func toggleEquip(itemID: UInt) -> InventoryViewModel {
        guard let inventory = game.level.player.inventoryComponent() else { fatalError("Inventory not found.") }
        if let itemComponent = itemComponent(for: itemID) {
            inventory.equip(itemComponent: itemComponent)
            self.updateHUD()
        }
        return inventoryViewModel(for: inventory, equipHandler: toggleEquip(itemID:))
    }
    
    private func itemComponent(for itemID: UInt) -> ItemComponent? {
        let items = game.entityManager.entities(with: ItemComponent.self)
        guard let item = items.first(where: { $0.entityId == itemID }) else { return nil }
        return item.itemComponent()
    }
}

func inventoryViewModel(for inventoryComponent: InventoryComponent,
                        equipHandler: @escaping InventoryViewModel.ActionHandler) -> InventoryViewModel {
    
    let items: [InventoryViewModel.ItemViewModel] = inventoryComponent.items.map {
        guard let itemID = $0.entity?.entityId else { fatalError("Missing entity ID for this item.") }
        let item = $0.item
        
        let isEquippable = item.equipmentSlot != nil
        let isEquipped = inventoryComponent.equippedItem(for: item.equipmentSlot) === $0
        let description = isEquipped ? itemDescription(item) + " (equipped)" : itemDescription(item)
        
        var actions = [InventoryViewModel.Action]()
        if isEquippable {
            let equipAction = inventoryEquipAction(itemIsEquipped: isEquipped, handler: equipHandler)
            actions.append(equipAction)
        }

        return InventoryViewModel.ItemViewModel(
            itemID: itemID,
            name: description,
            actions: actions)
    }
    return InventoryViewModel(items: items)
}

func inventoryEquipAction(itemIsEquipped: Bool,
                          handler: @escaping InventoryViewModel.ActionHandler) -> InventoryViewModel.Action {
    let actionName = itemIsEquipped ? "Unequip" : "Equip"
    return InventoryViewModel.Action(name: actionName, handler: handler)
}

private func itemDescription(_ item: Item) -> String {
    if let armor = item.armor {
        let baseArmorClass = 10 + armor.armorBonus
        return "Armor: \(item.name) (\(baseArmorClass))"
    }
    if let weapon = item.weapon {
        return "Weapon: \(item.name) (\(weapon.damageDice))"
    }
    return "Other: \(item.name)"
}
