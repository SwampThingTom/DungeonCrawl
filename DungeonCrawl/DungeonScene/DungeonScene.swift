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
    private var player = Player()
    
    private var gameState: DungeonTurnState = .waitingForInput {
        didSet {
            print("gameState is now \(gameState)")
        }
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
        var interactor = DungeonSceneInteractor()
        interactor.presenter = presenter
        interactor.dungeonGenerator = DungeonGenerator()
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
        addCamera()
    }
    
    private func addTileMap(_ tileMap: SKTileMapNode) {
        self.tileMap = tileMap
        addChild(tileMap)
    }
    
    private func addPlayer(position: CGPoint) {
        player.position = position
        addChild(player)
    }
    
    private func addCamera() {
        guard let view = view else {
            fatalError("Unable to get view for DungeonScene")
        }
        let camera = DungeonCamera(follow: player, mapNode: tileMap, viewBounds: view.bounds)
        addChild(camera)
        self.camera = camera
    }

    private func takePlayerTurn(_ playerAction: PlayerAction) {
        guard gameState == .waitingForInput else {
            return
        }
        interactor.takeTurn(playerAction: playerAction, tileMap: tileMap, playerNodeName: player.name!)
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
        guard let direction = Direction.direction(from: player.position, to: position) else {
            fatalError("Unable to calculate direction from \(player.position) to \(position)")
        }
        let playerCell = tileMap.cell(for: player.position)
        let targetCell = playerCell.neighbor(direction: direction)
        guard !tileMap.isObstacle(targetCell) else {
            return
        }
        let action = PlayerAction.move(to: targetCell, heading: direction)
        takePlayerTurn(action)
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
