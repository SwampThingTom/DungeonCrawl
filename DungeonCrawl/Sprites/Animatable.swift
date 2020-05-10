//
//  Animatable.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/9/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import SpriteKit

protocol Animatable: class {
    var heading: Direction { get set }
    var animations: [Direction: SKAction] { get set }
    var standingTexture: [Direction: SKTexture] { get set }
}

extension Animatable {
    
    func createAnimations(textureName: String) {
        createAnimation(for: .east, textureName: textureName, directionName: "East")
        createAnimation(for: .south, textureName: textureName, directionName: "South")
        createAnimation(for: .west, textureName: textureName, directionName: "West")
        createAnimation(for: .north, textureName: textureName, directionName: "North")
    }
    
    private func createAnimation(for direction: Direction, textureName: String, directionName: String) {
        let textures = [
            SKTexture(imageNamed: "\(textureName)_\(directionName)_02"),
            SKTexture(imageNamed: "\(textureName)_\(directionName)_03")
        ]
        animations[direction] = SKAction.animate(with: textures, timePerFrame: 0.2)
        standingTexture[direction] = SKTexture(imageNamed: "\(textureName)_\(directionName)_01")
    }
}
