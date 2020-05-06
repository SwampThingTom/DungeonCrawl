//
//  DungeonScene.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/5/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import SpriteKit
import GameplayKit

class DungeonScene: SKScene {
    
    let dungeonSize = GridSize(width: 25, height: 25)
    
    var tileSet: SKTileSet!
    var tileMap: SKTileMapNode!
    let tileSize = CGSize(width: 32, height: 32)
    
    override func sceneDidLoad() {
        guard let tileSet = SKTileSet(named: "Dungeon") else {
            fatalError("Unable to load DungeonTileSet")
        }
        self.tileSet = tileSet
        scaleMode = .resizeFill
    }
    
    override func didMove(to view: SKView) {
        newMap()
    }
    
    func newMap() {
        removeAllChildren()
        let dungeonGenerator = DungeonGenerator()
        let mapBuilder = DungeonTileMapBuilder(dungeonGenerator: dungeonGenerator,
                                               dungeonSize: dungeonSize,
                                               tileSet: tileSet,
                                               tileSize: tileSize)
        tileMap = mapBuilder.build()
        addChild(tileMap)
    }
    
    func touchDown(atPoint pos: CGPoint) {
    }
    
    func touchMoved(toPoint pos: CGPoint) {
    }
    
    func touchUp(atPoint pos: CGPoint) {
        newMap()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        newMap()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
