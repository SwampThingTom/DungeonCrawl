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
        clearMessages()
        let animations = game.takeTurn(playerAction: playerAction)
        let animationAction = animationActionForTurn(animations: animations)
        run(animationAction)
    }
    
    func displayEndOfTurn() {
        stopAnimations()
        removeDeadActors()
        if game.isQuestComplete {
            showPlayerWon()
            gameState = .dungeonComplete
            return
        } else if game.isPlayerDead {
            showPlayerDied()
            gameState = .dungeonComplete
            return
        }
        updateHUD()
        gameState = .waitingForInput
    }
    
    private func removeDeadActors() {
        let actorNames = [playerSpriteComponent!.spriteName] + game.level.actors.compactMap {
            guard let spriteComponent = $0.spriteComponent() else { return nil }
            return spriteComponent.spriteName
        }
        let nodesToRemove = children.filter { node in
            guard node is SKSpriteNode, let nodeName = node.name else { return false }
            return !actorNames.contains(nodeName)
        }
        removeChildren(in: nodesToRemove)
    }
    
    func showPlayerWon() {
        showAlert(message: "You have completed the quest!") {
            self.startNewGame()
        }
    }
    
    func showPlayerDied() {
        showAlert(message: "You have died!") {
            self.startNewGame()
        }
    }
}

extension SKScene {
    
    // LATER: Probably better to implement this in SpriteKit, or transition to new scene.
    func showAlert(message: String?, handler: (() -> Void)?) {
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in handler?() }
        alert.addAction(okAction)
        view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
