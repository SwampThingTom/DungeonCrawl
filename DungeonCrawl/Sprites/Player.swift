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
    
    private var targetPosition: CGPoint?
    
    init() {
        let texture = SKTexture(imageNamed: "Player_Female_South_01")
        super.init(texture: texture, color: .white, size: texture.size())
        name = "Player"
        zPosition = 50
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use default initializer")
    }
    
    func move(to newTargetPosition: CGPoint) {
        targetPosition = newTargetPosition
    }
    
    func update(_ deltaTime: TimeInterval) {
        move(deltaTime)
    }
    
    private func move(_ deltaTime: TimeInterval) {
        guard let targetPosition = targetPosition else { return }
        
        let offset = targetPosition - position
        let length = offset.length()
        guard length > PlayerSettings.speed / 60.0 else {
            position = targetPosition
            self.targetPosition = nil
            return
        }
        
        let velocity = (offset / length) * PlayerSettings.speed
        let distance = velocity * CGFloat(deltaTime)
        position += distance
    }
}
