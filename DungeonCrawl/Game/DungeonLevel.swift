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

protocol LevelProviding {
    var quest: QuestStatusProviding { get }
    var map: GridMap { get }
    var rooms: [RoomModel] { get }
    var player: Entity { get }
    var actors: [Entity] { get }
    var items: [Entity] { get }
    var message: MessageLogging? { get }
}

class DungeonLevel: LevelProviding {
    let quest: QuestStatusProviding
    let map: GridMap
    let rooms: [RoomModel]
    let entityManager: EntityManaging
    var message: MessageLogging?
    
    let player: Entity
    
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
