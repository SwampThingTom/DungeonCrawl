//
//  DungeonScene+DisplayScene.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/15/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import SpriteKit

extension DungeonScene {
    
    func displayScene(tileMap: SKTileMapNode, playerSprite: SKSpriteNode, enemySprites: [SKSpriteNode]) {
        addTileMap(tileMap)
        addPlayer(playerSprite)
        addEnemies(enemySprites)
        addCamera()
        addMessageLabel()
    }
    
    private var playableViewBounds: CGRect {
        guard let view = view else {
            fatalError("Unable to get view for DungeonScene")
        }
        let hudHeight: CGFloat = 160.0
        let playableViewSize = CGSize(width: view.bounds.size.width,
                                      height: view.bounds.size.height - hudHeight)
        return CGRect(origin: view.bounds.origin, size: playableViewSize)
    }

    private func addTileMap(_ tileMap: SKTileMapNode) {
        self.tileMap = tileMap
        addChild(tileMap)
    }
    
    private func addPlayer(_ sprite: SKSpriteNode) {
        addChild(sprite)
    }
    
    private func addEnemies(_ enemySprites: [SKSpriteNode]) {
        for sprite in enemySprites {
            addChild(sprite)
        }
    }
    
    private func addCamera() {
        guard let spriteComponent = game.entityManager.spriteComponent(for: game.level.player) else {
            fatalError("Unable to find player sprite")
        }
        guard let playerSprite = childNode(withName: spriteComponent.spriteName) else {
            fatalError("Unable to find player sprite")
        }
        let camera = DungeonCamera(follow: playerSprite, mapNode: tileMap, viewBounds: playableViewBounds)
        addChild(camera)
        self.camera = camera
    }
    
    private func addMessageLabel() {
        messageLabel.position = CGPoint(x: 0, y: 280)
        messageLabel.fontName = "Damascus"
        messageLabel.fontSize = 16
        messageLabel.numberOfLines = 2
        camera?.addChild(messageLabel)
    }
}
