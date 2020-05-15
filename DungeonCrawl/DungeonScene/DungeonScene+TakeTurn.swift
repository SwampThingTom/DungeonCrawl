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
        let animations = game.takeTurn(playerAction: playerAction)
        let animationAction = animationActionForTurn(animations: animations)
        run(animationAction)
    }
    
    func displayEndOfTurn() {
        stopAnimations()
        gameState = .waitingForInput
    }
}
