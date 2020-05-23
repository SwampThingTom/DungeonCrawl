//
//  TreasureComponent.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/23/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class TreasureComponent: Component {
    
    var gold: Int
    
    init(gold: Int) {
        self.gold = gold
    }
}

extension EntityManager {
    func treasureComponent(for entity: Entity) -> TreasureComponent? {
        return component(of: TreasureComponent.self, for: entity) as? TreasureComponent
    }
}

extension Entity {
    func treasureComponent() -> TreasureComponent? {
        return component(of: TreasureComponent.self) as? TreasureComponent
    }
}
