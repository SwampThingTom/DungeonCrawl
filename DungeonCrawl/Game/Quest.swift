//
//  Quest.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/18/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol QuestStatusProviding {
    
    var item: Item? { get }
    func isComplete(gameLevel: DungeonLevel) -> Bool
}

class QuestKillAllEnemies: QuestStatusProviding {
    
    let item: Item? = nil
    
    func isComplete(gameLevel: DungeonLevel) -> Bool {
        return gameLevel.actors.count == 0
    }
}

class QuestFindItem: QuestStatusProviding {
    
    let item: Item?
    
    init(item: Item) {
        self.item = item
    }
    
    func isComplete(gameLevel: DungeonLevel) -> Bool {
        guard let playerInventory = gameLevel.player.inventoryComponent() else {
            return false
        }
        return playerInventory.items.contains { $0.item == item }
    }
}
