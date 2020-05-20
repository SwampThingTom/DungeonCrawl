//
//  System.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/18/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

/// Abstract superclass for classes that provide game logic.
/// A system usually operates on one or more component types.
class System {
    
    let entityManager: EntityManager
    
    init(entityManager: EntityManager) {
        self.entityManager = entityManager
    }
}
