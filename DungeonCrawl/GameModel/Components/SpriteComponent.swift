//
//  SpriteComponent.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/17/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class SpriteComponent: Component {
    
    /// Identifies a unique Sprite object associated with this Entity.
    let spriteName: String
    
    /// Name shown in messages.
    let displayName: String
    
    /// Location on map.
    var cell: GridCell
    
    init(spriteName: String, displayName: String, cell: GridCell) {
        self.spriteName = spriteName
        self.displayName = displayName
        self.cell = cell
    }
}

extension EntityManager {
    
    func spriteComponent(for entity: Entity) -> SpriteComponent? {
        return component(of: SpriteComponent.self, for: entity) as? SpriteComponent
    }
}
