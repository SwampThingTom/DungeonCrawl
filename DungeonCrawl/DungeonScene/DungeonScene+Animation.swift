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
        let endOfTurnAction = runAtEndOfTurnAction { self.displayEndOfTurn() }
        let spriteActions = animations.map { spriteAction(for: $0) }
        guard spriteActions.count > 0 else {
            return endOfTurnAction
        }
        let turnAction = SKAction.group(spriteActions)
        return SKAction.sequence([turnAction, endOfTurnAction])
    }
    
    func stopAnimations() {
        for node in children {
            guard let sprite = node as? Animatable else { continue }
            sprite.stopAnimation()
        }
    }

    private func spriteAction(for actorAnimation: ActorAnimation) -> SKAction {
        guard let spriteComponent = game.entityManager.spriteComponent(for: actorAnimation.actor) else {
            fatalError("Unable to get sprite component for animation")
        }
        switch actorAnimation.animation {
        case .attack:
            let attackAction1 = SKAction.moveBy(x: 0.0, y: 8.0, duration: GameSettings.turnDuration / 2.0)
            let attackAction2 = SKAction.moveBy(x: 0.0, y: -8.0, duration: GameSettings.turnDuration / 2.0)
            let attackActions = SKAction.sequence([attackAction1, attackAction2])
            let action = SKAction.run(attackActions, onChildWithName: spriteComponent.spriteName)
            return action
                
        case .death:
            let spriteAction = SKAction.rotate(byAngle: CGFloat.pi, duration: GameSettings.turnDuration)
            let action = SKAction.run(spriteAction, onChildWithName: spriteComponent.spriteName)
            return action

        case .move(let cell, let heading):
            let position = tileMap.center(of: cell)
            animateSprite(heading: heading, forSpriteNamed: spriteComponent.spriteName)
            let spriteAction = SKAction.move(to: position, duration: GameSettings.turnDuration)
            let action = SKAction.run(spriteAction, onChildWithName: spriteComponent.spriteName)
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

extension SKTileMapNode {
    
    func cell(for position: CGPoint) -> GridCell {
        let x = tileColumnIndex(fromPosition: position)
        let y = tileRowIndex(fromPosition: position)
        return GridCell(x: x, y: y)
    }
    
    func center(of cell: GridCell) -> CGPoint {
        return centerOfTile(atColumn: cell.x, row: cell.y)
    }
    
    func isObstacle(_ cell: GridCell) -> Bool {
        let tile = tileDefinition(atColumn: cell.x, row: cell.y)
        return tile?.userData?.object(forKey: "obstacle") != nil
    }
}
