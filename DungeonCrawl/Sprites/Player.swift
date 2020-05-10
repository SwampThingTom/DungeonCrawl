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

enum PlayerActionKeys {
    static let animation = "animation"
}

class Player: SKSpriteNode, Animatable {
    
    var heading = Direction.south {
        didSet { texture = standingTexture[heading] }
    }
    var animations = [Direction: SKAction]()
    var standingTexture = [Direction: SKTexture]()
    
    init() {
        let textureName = "Player_Female"
        let texture = SKTexture(imageNamed: "\(textureName)_North_01")
        super.init(texture: texture, color: .white, size: texture.size())
        createAnimations(textureName: textureName)
        name = "Player"
        zPosition = 50
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use default initializer")
    }
    
    func startAnimation() {
        guard let animation = animations[heading] else { return }
        if action(forKey: PlayerActionKeys.animation) == nil {
            run(SKAction.repeatForever(animation), withKey: PlayerActionKeys.animation)
        }
    }
    
    func stopAnimation() {
        removeAction(forKey: PlayerActionKeys.animation)
    }
}
