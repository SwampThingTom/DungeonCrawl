//
//  Quest.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/18/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol QuestStatusProviding {
    
    func isComplete(gameLevel: LevelProviding) -> Bool
}

class Quest: QuestStatusProviding {
    
    func isComplete(gameLevel: LevelProviding) -> Bool {
        return gameLevel.actors.count == 0
    }
}
