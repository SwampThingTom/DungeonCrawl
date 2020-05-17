//
//  Entity.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/17/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class Entity {
    let entityId: UInt
    
    init(entityId: UInt) {
        self.entityId = entityId
    }
}

extension Entity: Hashable {
    static func == (lhs: Entity, rhs: Entity) -> Bool {
        return lhs.entityId == rhs.entityId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(entityId)
    }
}
