//
//  DungeonScene+Animation.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/15/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import SpriteKit

extension DungeonScene {
    
    func animationActionForTurn(animations: [ActorAnimation]) -> SKAction {
        let spriteActions = animations.map { spriteAction(for: $0) }
        let turnAction = SKAction.group(spriteActions)
        let endOfTurnAction = runAtEndOfTurnAction { self.displayEndOfTurn() }
        return SKAction.sequence([turnAction, endOfTurnAction])
    }
    
    func stopAnimations() {
        for node in children {
            guard let sprite = node as? Animatable else { continue }
            sprite.stopAnimation()
        }
    }

    private func spriteAction(for actorAnimation: ActorAnimation) -> SKAction {
        switch actorAnimation.animation {
        case .attack:
            let attackAction1 = SKAction.moveBy(x: 0.0, y: 8.0, duration: GameSettings.turnDuration / 2.0)
            let attackAction2 = SKAction.moveBy(x: 0.0, y: -8.0, duration: GameSettings.turnDuration / 2.0)
            let attackActions = SKAction.sequence([attackAction1, attackAction2])
            let action = SKAction.run(attackActions, onChildWithName: actorAnimation.actor.name)
            return action
            
        case .move(let cell, let heading):
            let position = tileMap.center(of: cell)
            animateSprite(heading: heading, forSpriteNamed: actorAnimation.actor.name)
            let spriteAction = SKAction.move(to: position, duration: GameSettings.turnDuration)
            let action = SKAction.run(spriteAction, onChildWithName: actorAnimation.actor.name)
            return action
        }
    }
    
    private func runAtEndOfTurnAction(_ block: @escaping () -> Void) -> SKAction {
        let waitAction = SKAction.wait(forDuration: GameSettings.turnDuration)
        let endOfTurnAction = SKAction.run(block)
        return SKAction.sequence([waitAction, endOfTurnAction])
    }
    
    private func animateSprite(heading: Direction, forSpriteNamed spriteName: String) {
        guard let sprite = childNode(withName: spriteName) as? Animatable else {
            print("Unable to update heading for sprite named \(spriteName)")
            return
        }
        sprite.heading = heading
        sprite.startAnimation()
    }
}
