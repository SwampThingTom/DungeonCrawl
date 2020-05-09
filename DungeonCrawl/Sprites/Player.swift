//
//  Player.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/6/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import SpriteKit

enum PlayerSettings {
    static let speed: CGFloat = 140.0
}

class Player: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "Player_Female_South_01")
        super.init(texture: texture, color: .white, size: texture.size())
        name = "Player"
        zPosition = 50
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use default initializer")
    }
}
