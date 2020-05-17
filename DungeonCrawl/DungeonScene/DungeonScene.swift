//
//  DungeonScene.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/5/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import SpriteKit

enum GameSettings {
    static let turnDuration: TimeInterval = 0.5
}

class DungeonScene: SKScene, MessageLogging {
    
    let tileSize = CGSize(width: 32, height: 32)
    var tileSet: SKTileSet!
    var tileMap: SKTileMapNode!
    
    var messageLabel = SKLabelNode()
    var messages = FixedSizeQueue<String>(maxSize: 2)
    
    var game: Game!
    
    var gameState: DungeonTurnState = .waitingForInput {
        didSet {
            print("gameState is now \(gameState)")
        }
    }
    
    override func sceneDidLoad() {
        guard let tileSet = SKTileSet(named: "Dungeon") else {
            fatalError("Unable to load Dungeon tile set")
        }
        self.tileSet = tileSet
        scaleMode = .resizeFill
    }
    
    override func didMove(to view: SKView) {
        game = createGame()
        game.level.message = self
        setupScene(for: game.level)
    }
    
    // MARK: - Display message
    
    func show(_ message: String) {
        messages.push(message)
        let lineOne = messages.first ?? ""
        let lineTwo = messages.last ?? ""
        self.messageLabel.text = lineOne + "\n" + lineTwo
    }
    
    // MARK: - Player input
    
    func handleMapTouch(at position: CGPoint) {
        guard let playerSprite = childNode(withName: game.level.player.spriteName) else {
            fatalError("Unable to find player sprite")
        }
        guard let direction = Direction.direction(from: playerSprite.position, to: position) else {
            fatalError("Unable to calculate direction from \(playerSprite.position) to \(position)")
        }
        let playerCell = tileMap.cell(for: playerSprite.position)
        let targetCell = playerCell.neighbor(direction: direction)
        guard !tileMap.isObstacle(targetCell) else {
            return
        }
        let action = playerAction(for: targetCell, direction: direction)
        takePlayerTurn(action)
    }
    
    private func playerAction(for cell: GridCell, direction: Direction) -> TurnAction {
        if isEnemy(cell) {
            return TurnAction.attack(direction: direction)
        }
        return TurnAction.move(to: cell, direction: direction)
    }
    
    private func isEnemy(_ cell: GridCell) -> Bool {
        for sprite in children {
            let isEnemy = sprite.userData?.object(forKey: "isEnemy") != nil
            if isEnemy && cell == tileMap.cell(for: sprite.position) {
                return true
            }
        }
        return false
    }
}
