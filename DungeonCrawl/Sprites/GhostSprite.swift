//
//  Ghost.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/10/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import SpriteKit

enum GhostActionKeys {
    static let animation = "animation"
}

class GhostSprite: SKSpriteNode, Animatable {
    
    var heading = Direction.south {
        didSet { texture = standingTexture[heading] }
    }
    var animations = [Direction: SKAction]()
    var standingTexture = [Direction: SKTexture]()
    
    init(spriteName: String) {
        let textureName = "Ghost"
        let texture = SKTexture(imageNamed: "\(textureName)_North_01")
        super.init(texture: texture, color: .white, size: texture.size())
        createAnimations(textureName: textureName)
        name = spriteName
        zPosition = 50
        userData = ["isEnemy": true]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use default initializer")
    }
    
    func startAnimation() {
    }
    
    func stopAnimation() {
    }
}
