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
    
    var hudView: HUDView?
    
    var messageLabel = SKLabelNode()
    var messages = FixedSizeQueue<String>(maxSize: 2)
    
    var game: Game!
    
    var gameState: DungeonTurnState = .waitingForInput {
        didSet {
            print("gameState is now \(gameState)")
        }
    }
    
    var playerSpriteComponent: SpriteComponent? {
        guard let playerSpriteComponent = game.level.player.spriteComponent() else {
            return nil
        }
        return playerSpriteComponent
    }
    
    override func sceneDidLoad() {
        guard let tileSet = SKTileSet(named: "Dungeon") else {
            fatalError("Unable to load Dungeon tile set")
        }
        self.tileSet = tileSet
        scaleMode = .resizeFill
    }
    
    override func didMove(to view: SKView) {
        startNewGame()
    }
    
    func startNewGame() {
        removeAllChildren()
        clearMessages()
        gameState = .waitingForInput
        game = createGame()
        game.level.message = self
        setupScene(for: game.level)
        updateHUD()
    }
    
    // MARK: - Display message
    
    func show(_ message: String) {
        messages.push(message)
        let lineOne = messages.first ?? ""
        let lineTwo = messages.last ?? ""
        self.messageLabel.text = lineOne + "\n" + lineTwo
    }
    
    func clearMessages() {
        show("")
        show("")
    }
    
    // MARK: - Player input
    
    func handleMapTouch(at position: CGPoint) {
        guard let playerSpriteComponent = playerSpriteComponent else {
            fatalError("Unable to find player sprite component")
        }
        guard let playerSprite = childNode(withName: playerSpriteComponent.spriteName) else {
            fatalError("Unable to find player sprite")
        }
        guard let direction = Direction.direction(from: playerSprite.position, to: position) else {
            fatalError("Unable to calculate direction from \(playerSprite.position) to \(position)")
        }
        let playerTurnProvider = game.playerTurnActionSystem
        if let action = playerTurnProvider.turnActionForMapTouch(direction: direction,
                                                                 playerSprite: playerSpriteComponent) {
            takePlayerTurn(action)
        }
    }
}

extension SKScene {
    
    var rootViewController: UIViewController? {
        return view?.window?.rootViewController
    }
}

extension DungeonScene: HUDDelegate {
    
    func updateHUD() {
        let player = game.level.player
        if let combat = player.combatComponent() {
            hudView?.healthLabel?.text = "\(combat.hitPoints) / \(combat.maxHitPoints)"
            let armorName = player.inventoryComponent()?.equippedItem(for: .armor)?.item.name ?? "none"
            hudView?.armorLabel?.text = "\(armorName) (\(combat.armorClass))"
            let weaponName = player.inventoryComponent()?.equippedItem(for: .weapon)?.item.name ?? "unarmed"
            hudView?.weaponLabel?.text = weaponName
        }
        if let items = player.inventoryComponent() {
            hudView?.goldLabel?.text = "Gold: \(items.gold)"
        }
    }
    
    func attack() {
    }

    func rest() {
    }
    
    func showInventory() {
        presentInventoryView()
    }

    func showPlayer() {
    }
}
