//
//  Player.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/6/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import SpriteKit

enum PlayerSettings {
    static let playerSpeed: CGFloat = 280.0
}

class Player: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "Player_Female_South_01")
        super.init(texture: texture, color: .white, size: texture.size())
        name = "Player"
        zPosition = 50
        
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.restitution = 1.0
        physicsBody?.linearDamping = 0.5
        physicsBody?.friction = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use default initializer")
    }
    
    func move(target: CGPoint) {
        guard let physicsBody = physicsBody else { return }
        let newVelocity = (target - position).normalized() * PlayerSettings.playerSpeed
        physicsBody.velocity = CGVector(point: newVelocity)
    }
}
