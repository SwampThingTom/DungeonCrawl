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
        let quest = Quest()
        let game = Game(dungeonGenerator: dungeonGenerator,
                        dungeonDecorator: dungeonDecorator,
                        dungeonSize: dungeonSize,
                        quest: quest)
        return game
    }
    
    func setupScene(for level: LevelProviding) {
        let tileMap = self.tileMap(for: level.map)
        let sprites = [SKSpriteNode]([
            [sprite(forPlayer: level.player, on: tileMap)],
            self.sprites(forEnemies: level.actors, on: tileMap),
            self.sprites(forTreasure: level.treasure, on: tileMap),
            self.sprites(forItems: level.items, on: tileMap)
        ].joined())
        displayScene(tileMap: tileMap, sprites: sprites)
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
    
    private func sprite(forPlayer player: Entity, on map: SKTileMapNode) -> SKSpriteNode {
        guard let spriteComponent = player.spriteComponent() else {
            fatalError("Unable to get sprite component for player.")
        }
        let sprite = PlayerSprite(spriteName: spriteComponent.spriteName)
        sprite.position = map.centerOfTile(atColumn: spriteComponent.cell.x, row: spriteComponent.cell.y)
        return sprite
    }
    
    private func sprites(forEnemies enemies: [Entity], on map: SKTileMapNode) -> [SKSpriteNode] {
        let enemySpriteProvider = EnemySpriteProvider()
        return enemies.compactMap { enemy in
            guard let spriteComponent = enemy.spriteComponent() else {
                fatalError("Unable to get sprite component for enemy")
            }
            guard let enemyComponent = enemy.enemyComponent() else {
                fatalError("Unable to get AI component for enemy")
            }
            let sprite = enemySpriteProvider.sprite(for: enemyComponent.enemyType,
                                                    spriteName: spriteComponent.spriteName)
            sprite?.position = map.centerOfTile(atColumn: spriteComponent.cell.x, row: spriteComponent.cell.y)
            return sprite
        }
    }
    
    private func sprites(forTreasure treasure: [Entity], on map: SKTileMapNode) -> [SKSpriteNode] {
        return treasure.compactMap { object in
            guard let spriteComponent = object.spriteComponent() else {
                return nil
            }
            guard object.treasureComponent() != nil else {
                return nil
            }
            let sprite = ObjectSprite(spriteName: spriteComponent.spriteName, textureName: "gold")
            sprite.position = map.centerOfTile(atColumn: spriteComponent.cell.x, row: spriteComponent.cell.y)
            return sprite
        }
    }
    
    private func sprites(forItems packItems: [Entity], on map: SKTileMapNode) -> [SKSpriteNode] {
        return packItems.compactMap { packItem in
            guard let spriteComponent = packItem.spriteComponent() else {
                return nil
            }
            guard packItem.itemComponent() != nil else {
                return nil
            }
            let sprite = ObjectSprite(spriteName: spriteComponent.spriteName, textureName: "treasure")
            sprite.position = map.centerOfTile(atColumn: spriteComponent.cell.x, row: spriteComponent.cell.y)
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
