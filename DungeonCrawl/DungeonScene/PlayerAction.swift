//
//  PlayerAction.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/9/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

enum PlayerAction {
    case attack
    case move(to: GridCell, heading: Direction)
    case pickUp
    case rest
    case use
}
