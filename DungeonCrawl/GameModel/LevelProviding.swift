//
//  LevelProviding.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/10/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import SpriteKit

protocol LevelProviding {
    var map: GridMap { get }
    var player: Actor { get }
    var actors: [AIActor] { get }
}
