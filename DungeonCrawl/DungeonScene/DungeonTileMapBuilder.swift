//
//  DungeonTileMapBuilder.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/5/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import SpriteKit

protocol TileMapBuilder {
    func build() -> SKTileMapNode
}

struct DungeonTileMapBuilder: TileMapBuilder {
    
    private let dungeonGenerator: DungeonGenerating
    private let dungeonSize: GridSize
    private let tileSet: SKTileSet
    private let tileSize: CGSize
    
    init(dungeonGenerator: DungeonGenerating, dungeonSize: GridSize, tileSet: SKTileSet, tileSize: CGSize) {
        self.dungeonGenerator = dungeonGenerator
        self.dungeonSize = dungeonSize
        self.tileSet = tileSet
        self.tileSize = tileSize
    }
    
    func build() -> SKTileMapNode {
        let dungeon = dungeonGenerator.generate(size: dungeonSize)
        let tileMap = SKTileMapNode(tileSet: tileSet,
                                    columns: dungeonSize.width,
                                    rows: dungeonSize.height,
                                    tileSize: tileSize)
        for x in 0 ..< dungeonSize.width {
            for y in 0 ..< dungeonSize.height {
                let cell = GridCell(x: x, y: y)
                if let tile = dungeon.map.tile(at: cell) {
                    tileMap.setCell(cell, to: tile)
                }
            }
        }
        return tileMap
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
