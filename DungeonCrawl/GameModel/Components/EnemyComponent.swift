//
//  EnemyComponent.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/17/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

class EnemyComponent: Component {
    
    let enemyType: EnemyType
    
    init(enemyType: EnemyType) {
        self.enemyType = enemyType
    }
}

enum EnemyType: Equatable {
    case ghost
}

extension EnemyType: CustomStringConvertible {
    var description: String {
        switch self {
        case .ghost: return "ghost"
        }
    }
}

extension EntityManager {
    
    func enemyComponent(for entity: Entity) -> EnemyComponent? {
        return component(of: EnemyComponent.self, for: entity) as? EnemyComponent
    }
}
