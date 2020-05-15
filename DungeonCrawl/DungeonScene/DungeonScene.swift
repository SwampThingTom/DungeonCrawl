//
//  DungeonScene.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/5/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol DungeonSceneDisplaying {
    func displayActionForTurn(action: SKAction)
    func animateSprite(heading: Direction, forSpriteNamed spriteName: String)
    func displayEndOfTurn()
}

class DungeonScene: SKScene, DungeonSceneDisplaying {
    
    private var interactor: DungeonSceneInteracting!
    
    private let tileSize = CGSize(width: 32, height: 32)
    private var tileSet: SKTileSet!
    private var tileMap: SKTileMapNode!
    private var playerSprite = PlayerSprite()
    
    private var game: Game!
    
    private var gameState: DungeonTurnState = .waitingForInput {
        didSet {
            print("gameState is now \(gameState)")
        }
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
    
    override func sceneDidLoad() {
        guard let tileSet = SKTileSet(named: "Dungeon") else {
            fatalError("Unable to load DungeonTileSet")
        }
        self.tileSet = tileSet
        scaleMode = .resizeFill
    }
    
    override func didMove(to view: SKView) {
        game = createGame()
        setupScene(for: game.level)
    }

    private func takePlayerTurn(_ playerAction: PlayerAction) {
        guard gameState == .waitingForInput else {
            return
        }
        interactor.takeTurn(playerAction: playerAction, tileMap: tileMap, playerNodeName: playerSprite.name!)
    }
    
    func displayActionForTurn(action: SKAction) {
        gameState = .takingTurn
        run(action)
    }
    
    func animateSprite(heading: Direction, forSpriteNamed spriteName: String) {
        guard let sprite = childNode(withName: spriteName) as? Animatable else {
            print("Unable to update heading for sprite named \(spriteName)")
            return
        }
        sprite.heading = heading
        sprite.startAnimation()
    }
    
    func displayEndOfTurn() {
        stopAnimations()
        gameState = .waitingForInput
    }
    
    func stopAnimations() {
        for node in children {
            guard let sprite = node as? Animatable else { continue }
            sprite.stopAnimation()
        }
    }
    
    // MARK: - Player input
    
    private func touchDown(at position: CGPoint) {
    }
    
    private func touchMoved(to position: CGPoint) {
    }
    
    private func touchUp(at position: CGPoint) {
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
    
    private func playerAction(for cell: GridCell, direction: Direction) -> PlayerAction {
        if isEnemy(cell) {
            return PlayerAction.attack(heading: direction)
        }
        return PlayerAction.move(to: cell, heading: direction)
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchDown(at: touch.location(in: self))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchMoved(to: touch.location(in: self))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchUp(at: touch.location(in: self))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}

// MARK: - Setup

extension DungeonScene {
    
    func createGame() -> Game {
        let dungeonGenerator = DungeonGenerator()
        let dungeonDecorator = DungeonDecorator()
        let dungeonSize = GridSize(width: 25, height: 25)
        let game = Game(dungeonGenerator: dungeonGenerator,
                        dungeonDecorator: dungeonDecorator,
                        dungeonSize: dungeonSize)
        return game
    }
    
    func setupScene(for level: LevelProviding) {
        let tileMap = self.tileMap(for: level.map)
        let playerStartCell = level.player.cell
        let playerStartPosition = tileMap.centerOfTile(atColumn: playerStartCell.x, row: playerStartCell.y)
        let enemies = sprites(for: level.actors, on: tileMap)
        displayScene(tileMap: tileMap, playerStartPosition: playerStartPosition, enemySprites: enemies)
    }
    
    private func tileMap(for map: GridMap) -> SKTileMapNode {
        let tileMap = SKTileMapNode(tileSet: tileSet,
                                    columns: map.size.width,
                                    rows: map.size.height,
                                    tileSize: tileSize)
        for x in 0 ..< map.size.width {
            for y in 0 ..< map.size.height {
                let cell = GridCell(x: x, y: y)
                if let tile = map.tile(at: cell) {
                    tileMap.setCell(cell, to: tile)
                }
            }
        }
        return tileMap
    }
    
    private func sprites(for enemies: [AIActor], on map: SKTileMapNode) -> [SKSpriteNode] {
        let enemySpriteProvider = EnemySpriteProvider()
        return enemies.compactMap { enemy in
            let sprite = enemySpriteProvider.sprite(for: enemy.enemyType)
            sprite?.position = map.centerOfTile(atColumn: enemy.cell.x, row: enemy.cell.y)
            return sprite
        }
    }
}

// MARK: - Display Scene

extension DungeonScene {
    
    func displayScene(tileMap: SKTileMapNode, playerStartPosition: CGPoint, enemySprites: [SKSpriteNode]) {
        addTileMap(tileMap)
        addPlayer(position: playerStartPosition)
        addEnemies(enemySprites)
        addCamera()
    }
    
    private func addTileMap(_ tileMap: SKTileMapNode) {
        self.tileMap = tileMap
        addChild(tileMap)
    }
    
    private func addPlayer(position: CGPoint) {
        playerSprite.position = position
        addChild(playerSprite)
    }
    
    private func addEnemies(_ enemySprites: [SKSpriteNode]) {
        for sprite in enemySprites {
            addChild(sprite)
        }
    }
    
    private func addCamera() {
        let camera = DungeonCamera(follow: playerSprite, mapNode: tileMap, viewBounds: playableViewBounds)
        addChild(camera)
        self.camera = camera
    }
}
