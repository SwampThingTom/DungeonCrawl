//
//  ObjectSprite.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/23/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import SpriteKit

class ObjectSprite: SKSpriteNode {
        
    init(textureName: String) {
        let texture = SKTexture(imageNamed: textureName)
        super.init(texture: texture, color: .white, size: texture.size())
        zPosition = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use default initializer")
    }
}
