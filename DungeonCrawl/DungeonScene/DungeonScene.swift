//
//  DungeonScene.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/5/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol DungeonSceneDisplaying {
    func displayScene(tileMap: SKTileMapNode, playerStartPosition: CGPoint)
}

class DungeonScene: SKScene, DungeonSceneDisplaying {
    
    var interactor: DungeonSceneInteracting!
    
    let tileSize = CGSize(width: 32, height: 32)
    var tileSet: SKTileSet!
    var tileMap: SKTileMapNode!
    var player = Player()
        
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

    func displayScene(tileMap: SKTileMapNode, playerStartPosition: CGPoint) {
        removeAllChildren()
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
        let camera = createCamera()
        addChild(camera)
        self.camera = camera
    }
    
    private func createCamera() -> SKCameraNode {
        let camera = SKCameraNode()
        let zero = SKRange(constantValue: 0)
        let followPlayer = SKConstraint.distance(zero, to: player)
        camera.constraints = [followPlayer]
        return camera

    func touchDown(at pos: CGPoint) {
        player.move(target: pos)
    }
    
    func touchMoved(to pos: CGPoint) {
    }
    
    func touchUp(at pos: CGPoint) {
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
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
