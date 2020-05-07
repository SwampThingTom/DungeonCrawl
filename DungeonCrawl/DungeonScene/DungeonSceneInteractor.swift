//
//  DungeonSceneInteractor.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/6/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

protocol DungeonSceneInteracting {
    func createScene(dungeonSize: GridSize)
}

struct DungeonSceneInteractor: DungeonSceneInteracting {
    
    var presenter: DungeonScenePresenting?
    var dungeonGenerator: DungeonGenerating?
    
    func createScene(dungeonSize: GridSize) {
        guard let presenter = presenter else { return }
        guard let dungeonModel = dungeonGenerator?.generate(size: dungeonSize) else { return }
        presenter.presentScene(dungeon: dungeonModel)
    }
}
