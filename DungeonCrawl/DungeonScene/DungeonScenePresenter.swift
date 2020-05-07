//
//  DungeonScenePresenter.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/6/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

protocol DungeonScenePresenting {
    func presentScene(dungeon: DungeonModel)
}

struct DungeonScenePresenter: DungeonScenePresenting {
    
    func presentScene(dungeon: DungeonModel) {
    }
}
