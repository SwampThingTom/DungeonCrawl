//
//  EnemySpriteProvider.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/10/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import SpriteKit

protocol EnemySpriteProviding {
    func sprite(for enemyType: EnemyType, name: String) -> SKSpriteNode?
}

class EnemySpriteProvider: EnemySpriteProviding {
    
    func sprite(for enemyType: EnemyType, name: String) -> SKSpriteNode? {
        switch enemyType {
        case .ghost:
            return Ghost(name: name)
        }
    }
}
