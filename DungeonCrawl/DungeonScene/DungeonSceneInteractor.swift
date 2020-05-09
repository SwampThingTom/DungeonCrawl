//
//  DungeonSceneInteractor.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/6/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import CoreGraphics

enum SpriteAction: Equatable {
    case move(to: CGPoint)
}

struct NodeAction: Equatable {
    let nodeName: String
    let action: SpriteAction
}

protocol DungeonSceneInteracting {
    func createScene(dungeonSize: GridSize)
    func takeTurn(playerAction: PlayerAction, tileMap: GridCellProviding, playerNodeName: String)
}

struct DungeonSceneInteractor: DungeonSceneInteracting {
    
    var presenter: DungeonScenePresenting?
    var dungeonGenerator: DungeonGenerating?
    
    func createScene(dungeonSize: GridSize) {
        guard let presenter = presenter else { return }
        guard let dungeonModel = dungeonGenerator?.generate(size: dungeonSize) else { return }
        guard let playerStartCell = self.playerStartCell(in: dungeonModel.map) else { return }
        presenter.presentScene(dungeon: dungeonModel, playerStartCell: playerStartCell)
    }
    
    private func playerStartCell(in map: GridMap) -> GridCell? {
        for x in 0 ..< map.size.width {
            for y in 0 ..< map.size.height {
                let cell = GridCell(x: x, y: y)
                if map.tile(at: cell) == .floor {
                    return cell
                }
            }
        }
        return nil
    }

    func takeTurn(playerAction: PlayerAction, tileMap: GridCellProviding, playerNodeName: String) {
        let playerNodeAction = nodeAction(for: playerAction, tileMap: tileMap, nodeName: playerNodeName)
        guard let nodeAction = playerNodeAction else {
            return
        }
        presenter?.presentActionsForTurn(actions: [nodeAction]) {
            self.presenter?.presentEndOfTurn()
        }
    }
    
    private func nodeAction(for playerAction: PlayerAction,
                            tileMap: GridCellProviding,
                            nodeName: String) -> NodeAction? {
        switch playerAction {
        case .attack:
            return nil
            
        case .move(let cell):
            let position = tileMap.center(of: cell)
            return NodeAction(nodeName: nodeName, action: .move(to: position))
            
        case .pickUp:
            return nil
            
        case .rest:
            return nil
            
        case .use:
            return nil
        }
    }
}
