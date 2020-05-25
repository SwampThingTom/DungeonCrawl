//
//  PlayerTurnActionSystem.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/19/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol PlayerTurnActionProviding {
    
    /// Returns the action to be taken this turn based on the player tapping on the map in a given direction.
    ///
    /// - Parameter direction: The direction the player tapped relative to their sprite.
    /// - Parameter playerSprite: The player's sprite component.
    /// - Returns: An action.
    func turnActionForMapTouch(direction: Direction, playerSprite: SpriteComponent) -> TurnAction?
}

class PlayerTurnActionSystem: System, PlayerTurnActionProviding {
    
    let gameLevel: DungeonLevel
    
    init(entityManager: EntityManager, gameLevel: DungeonLevel) {
        self.gameLevel = gameLevel
        super.init(entityManager: entityManager)
    }

    func turnActionForMapTouch(direction: Direction, playerSprite: SpriteComponent) -> TurnAction? {
        let targetCell = playerSprite.cell.neighbor(direction: direction)
        guard let targetTile = gameLevel.map.tile(at: targetCell) else { return nil }
        guard !targetTile.isObstacle else { return nil }
        return action(for: targetCell, direction: direction)
    }
    
    private func action(for cell: GridCell, direction: Direction) -> TurnAction {
        if isEnemy(cell) {
            return TurnAction.attack(direction: direction)
        }
        return TurnAction.move(to: cell, direction: direction)
    }
    
    private func isEnemy(_ cell: GridCell) -> Bool {
        let enemy = gameLevel.actors.first {
            guard $0.enemyComponent() != nil else { return false }
            guard let sprite = $0.spriteComponent() else { return false }
            return sprite.cell == cell
        }
        return enemy != nil
    }
}
