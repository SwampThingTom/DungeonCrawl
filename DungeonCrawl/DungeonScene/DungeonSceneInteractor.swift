//
//  DungeonSceneInteractor.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/6/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import CoreGraphics

enum SpriteAction: Equatable {
    case move(to: CGPoint, heading: Direction)
    case attack(heading: Direction)
}

struct NodeAction: Equatable {
    let nodeName: String
    let action: SpriteAction
}

protocol DungeonSceneInteracting {
    func takeTurn(playerAction: PlayerAction, tileMap: GridCellProviding, playerNodeName: String)
}

struct DungeonSceneInteractor: DungeonSceneInteracting {
    
    var presenter: DungeonScenePresenting?

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
        case .attack(let heading):
            let spriteAction = SpriteAction.attack(heading: heading)
            return NodeAction(nodeName: nodeName, action: spriteAction)

        case .move(let cell, let heading):
            let position = tileMap.center(of: cell)
            let spriteAction = SpriteAction.move(to: position, heading: heading)
            return NodeAction(nodeName: nodeName, action: spriteAction)
            
        case .pickUp:
            return nil
            
        case .rest:
            return nil
            
        case .use:
            return nil
        }
    }
}
