//
//  EnemySpriteProvider.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/10/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import SpriteKit

protocol EnemySpriteProviding {
    func sprite(for enemyType: EnemyType, spriteName: String) -> SKSpriteNode?
}

class EnemySpriteProvider: EnemySpriteProviding {
    
    func sprite(for enemyType: EnemyType, spriteName: String) -> SKSpriteNode? {
        let textureName = self.textureName(for: enemyType)
        return EnemySprite(spriteName: spriteName, textureName: textureName)
    }
    
    private func textureName(for enemyType: EnemyType) -> String {
        switch enemyType {
        case .ghast:
            return "Zombie"
        case .giantBat:
            return "Bat"
        case .giantSpider:
            return "Spider"
        case .jellyCube:
            return "Ooze"
        case .shadow:
            return "Ghost"
        case .skeleton:
            return "Skeleton"
        }
    }
}
