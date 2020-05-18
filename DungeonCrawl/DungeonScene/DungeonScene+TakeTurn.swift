//
//  DungeonScene+TakeTurn.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/15/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import SpriteKit

extension DungeonScene {
    
    func takePlayerTurn(_ playerAction: TurnAction) {
        guard gameState == .waitingForInput else {
            return
        }
        gameState = .takingTurn
        show("")
        let animations = game.takeTurn(playerAction: playerAction)
        let animationAction = animationActionForTurn(animations: animations)
        run(animationAction)
    }
    
    func displayEndOfTurn() {
        stopAnimations()
        let actorNames = [playerSpriteComponent!.spriteName] + game.level.actors.compactMap {
            guard let spriteComponent = game.entityManager.spriteComponent(for: $0) else { return nil }
            return spriteComponent.spriteName
        }
        let nodesToRemove = children.filter { node in
            guard node is SKSpriteNode, let nodeName = node.name else { return false }
            return !actorNames.contains(nodeName)
        }
        removeChildren(in: nodesToRemove)
        gameState = .waitingForInput
    }
}
