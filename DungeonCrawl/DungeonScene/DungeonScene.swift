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
    var dungeonModel: DungeonModel!
    
    var tileSet: SKTileSet!
    var tileMap: SKTileMapNode!
    var player = Player()
    
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
    
    private func newMap() {
        removeAllChildren()
        generateDungeon()
        buildTileMap()
        decorateDungeon()
    }
    
    private func generateDungeon() {
        let dungeonGenerator = DungeonGenerator()
        dungeonModel = dungeonGenerator.generate(size: dungeonSize)
    }
    
    private func buildTileMap() {
        let mapBuilder = DungeonTileMapBuilder(map: dungeonModel.map,
                                               tileSet: tileSet,
                                               tileSize: tileSize)
        tileMap = mapBuilder.build()
        addChild(tileMap)
    }
    
    private func decorateDungeon() {
        let dungeonDecorator = DungeonDecorator(dungeon: dungeonModel)
        guard let cell = dungeonDecorator.playerStartCell() else {
            fatalError("Unable to create a starting location for the player")
        }
        player.position = tileMap.centerOfTile(atColumn: cell.x, row: cell.y)
        addChild(player)
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
