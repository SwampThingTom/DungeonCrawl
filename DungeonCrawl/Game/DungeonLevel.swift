//
//  DungeonLevel.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/10/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol MessageLogging {
    func show(_ message: String)
}

class DungeonLevel {
    let quest: QuestStatusProviding
    let map: GridMap
    let rooms: [RoomModel]
    let entityManager: EntityManaging
    var message: MessageLogging?
    
    let player: Entity
    
    // LATER: Do these really belong here or with EntityManaging?
    // This tightly couples this struct to EntityManaging
    var actors: [Entity] {
        return entityManager.entities(with: EnemyComponent.self)
    }
    
    var items: [Entity] {
        return entityManager.entities(with: ItemComponent.self)
    }
    
    init(quest: QuestStatusProviding,
         map: GridMap,
         rooms: [RoomModel],
         entityManager: EntityManaging,
         player: Entity) {
        self.quest = quest
        self.map = map
        self.rooms = rooms
        self.entityManager = entityManager
        self.player = player
    }
}
