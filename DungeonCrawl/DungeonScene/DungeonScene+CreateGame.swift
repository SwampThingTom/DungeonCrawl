//
//  DungeonScene+CreateGame.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/15/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import SpriteKit

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
            let sprite = enemySpriteProvider.sprite(for: enemy.enemyType, name: enemy.name)
            sprite?.position = map.centerOfTile(atColumn: enemy.cell.x, row: enemy.cell.y)
            return sprite
        }
    }
}

extension SKTileMapNode {
    
    func setCell(_ cell: GridCell, to tile: Tile) {
        let tileGroup = tileSet.tileGroup(for: tile)
        setTileGroup(tileGroup, forColumn: cell.x, row: cell.y)
    }
}

extension SKTileSet {

    func tileGroup(for tile: Tile) -> SKTileGroup {
        switch tile {
        case .wall:
            return wallTileGroup
        case .floor:
            return floorTileGroup
        case .door:
            return doorTileGroup
        }
    }

    var wallsTileGroup: SKTileGroup {
        // LATER: use adjacency group rules
        return tileGroup(named: "Walls")
    }

    var wallTileGroup: SKTileGroup {
        return tileGroup(named: "Wall")
    }

    var floorTileGroup: SKTileGroup {
        return tileGroup(named: "Floor")
    }

    var doorTileGroup: SKTileGroup {
        return tileGroup(named: "Door")
    }

    func tileGroup(named name: String) -> SKTileGroup {
        guard let tileGroup = self.tileGroups.first(where: { $0.name == name }) else {
            fatalError("Unable to find tile group named \(name)")
        }
        return tileGroup
    }
}
