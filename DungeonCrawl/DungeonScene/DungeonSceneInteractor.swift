//
//  DungeonSceneInteractor.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/6/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import CoreGraphics

protocol DungeonSceneInteracting {
}

struct DungeonSceneInteractor: DungeonSceneInteracting {
    
    var presenter: DungeonScenePresenting?
}
