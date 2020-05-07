//
//  DungeonScenePresenter.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/6/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import SpriteKit

protocol DungeonScenePresenting {
    func presentScene(dungeon: DungeonModel, playerStartCell: GridCell)
}

struct DungeonScenePresenter: DungeonScenePresenting {
    
    var scene: DungeonSceneDisplaying?
    var tileSet: SKTileSet
    var tileSize: CGSize
    
    func presentScene(dungeon: DungeonModel, playerStartCell: GridCell) {
        let tileMap = self.tileMap(for: dungeon.map)
        let playerStartPosition = tileMap.centerOfTile(atColumn: playerStartCell.x, row: playerStartCell.y)
        scene?.displayScene(tileMap: tileMap, playerStartPosition: playerStartPosition)
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
}
