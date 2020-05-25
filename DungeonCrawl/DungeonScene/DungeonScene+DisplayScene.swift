//
//  DungeonScene+DisplayScene.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/15/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import SpriteKit

extension DungeonScene {
    
    func displayScene(tileMap: SKTileMapNode, sprites: [SKSpriteNode]) {
        addTileMap(tileMap)
        addSprites(sprites)
        addCamera()
        addMessageLabel()
    }
    
    private var playableViewBounds: CGRect {
        guard let view = view else {
            fatalError("Unable to get view for DungeonScene")
        }
        let playableViewSize = CGSize(width: view.bounds.size.width,
                                      height: view.bounds.size.height)
        return CGRect(origin: view.bounds.origin, size: playableViewSize)
    }

    private func addTileMap(_ tileMap: SKTileMapNode) {
        self.tileMap = tileMap
        addChild(tileMap)
    }
    
    private func addSprites(_ sprites: [SKSpriteNode]) {
        for sprite in sprites {
            addChild(sprite)
        }
    }
    
    private func addCamera() {
        guard let spriteComponent = game.level.player.spriteComponent() else {
            fatalError("Unable to find player sprite")
        }
        guard let playerSprite = childNode(withName: spriteComponent.spriteName) else {
            fatalError("Unable to find player sprite")
        }
        let hudHeight: CGFloat = 160
        let camera = DungeonCamera(follow: playerSprite,
                                   mapNode: tileMap,
                                   viewBounds: playableViewBounds,
                                   hudHeight: hudHeight)
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
