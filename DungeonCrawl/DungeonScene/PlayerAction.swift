//
//  PlayerAction.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/9/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

enum PlayerAction {
    case attack
    case move(to: GridCell)
    case pickUp
    case rest
    case use
}
