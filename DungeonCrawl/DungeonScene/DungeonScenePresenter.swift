//
//  DungeonScenePresenter.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/6/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import SpriteKit

enum GameSettings {
    static let turnDuration: TimeInterval = 0.5
}

protocol DungeonScenePresenting {
    func presentScene(dungeon: DungeonModel, playerStartCell: GridCell)
    func presentActionsForTurn(actions: [NodeAction], endOfTurnBlock: @escaping () -> Void)
    func presentEndOfTurn()
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
    
    func presentActionsForTurn(actions: [NodeAction], endOfTurnBlock: @escaping () -> Void) {
        let spriteActions = actions.map { spriteAction(for: $0) }
        let turnAction = SKAction.group(spriteActions)        
        let endOfTurnAction = runAtEndOfTurnAction(endOfTurnBlock)
        let action = SKAction.sequence([turnAction, endOfTurnAction])
        scene?.displayActionForTurn(action: action)
    }
    
    private func spriteAction(for nodeAction: NodeAction) -> SKAction {
        switch nodeAction.action {
        case .move(let position, let heading):
            scene?.animateSprite(heading: heading, forSpriteNamed: nodeAction.nodeName)
            let spriteAction = SKAction.move(to: position, duration: GameSettings.turnDuration)
            let action = SKAction.run(spriteAction, onChildWithName: nodeAction.nodeName)
            return action
        }
    }
    
    private func runAtEndOfTurnAction(_ block: @escaping () -> Void) -> SKAction {
        let waitAction = SKAction.wait(forDuration: GameSettings.turnDuration)
        let endOfTurnAction = SKAction.run(block)
        return SKAction.sequence([waitAction, endOfTurnAction])
    }
    
    func presentEndOfTurn() {
        scene?.displayEndOfTurn()
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
