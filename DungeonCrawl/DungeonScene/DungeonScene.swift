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
    func displayScene(tileMap: SKTileMapNode, playerStartPosition: CGPoint, enemySprites: [SKSpriteNode])
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
        setup()
    }
    
    private func setup() {
        var presenter = DungeonScenePresenter(tileSet: tileSet, tileSize: tileSize)
        presenter.scene = self
        presenter.enemySpriteProvider = EnemySpriteProvider()
        
        var interactor = DungeonSceneInteractor()
        interactor.presenter = presenter
        interactor.dungeonGenerator = DungeonGenerator()
        interactor.dungeonDecorator = DungeonDecorator()
        self.interactor = interactor
    }
    
    override func didMove(to view: SKView) {
        let dungeonSize = GridSize(width: 25, height: 25)
        interactor.createScene(dungeonSize: dungeonSize)
    }
    
    // MARK: - DungeonSceneDisplaying
    
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
