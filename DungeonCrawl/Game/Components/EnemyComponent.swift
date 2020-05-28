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
    var enemyAIState: EnemyAIState = .walk
    var targetCell: GridCell?
    
    init(enemyType: EnemyType) {
        self.enemyType = enemyType
    }
}

enum EnemyAIState: Equatable {
    case chase
    case wait
    case walk
}

enum EnemyType: Equatable {
    case ghast
    case giantBat
    case giantSpider
    case jellyCube
    case shadow
    case skeleton
}

extension EnemyType: CustomStringConvertible {
    var description: String {
        switch self {
        case .ghast: return "ghast"
        case .giantBat: return "giant bat"
        case .giantSpider: return "giant spider"
        case .jellyCube: return "jelly cube"
        case .shadow: return "shadow"
        case .skeleton: return "skeleton"
        }
    }
}

extension EntityManager {
    func enemyComponent(for entity: Entity) -> EnemyComponent? {
        return component(of: EnemyComponent.self, for: entity) as? EnemyComponent
    }
}

extension Entity {
    func enemyComponent() -> EnemyComponent? {
        return component(of: EnemyComponent.self) as? EnemyComponent
    }
}
