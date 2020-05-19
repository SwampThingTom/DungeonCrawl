//
//  LevelProviding.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/10/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol MessageLogging {
    func show(_ message: String)
}

protocol LevelProviding {
    var quest: QuestStatusProviding { get }
    var map: GridMap { get }
    var player: Entity { get }
    var actors: [Entity] { get }
    var message: MessageLogging? { get }
}
