//
//  EnemyType.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/28/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

enum EnemyType: Equatable {
    case ghast
    case giantBat
    case giantSpider
    case jellyCube
    case shadow
    case skeleton
}

extension EnemyType: CustomStringConvertible {
    var description: String {
        switch self {
        case .ghast: return "ghast"
        case .giantBat: return "giant bat"
        case .giantSpider: return "giant spider"
        case .jellyCube: return "jelly cube"
        case .shadow: return "shadow"
        case .skeleton: return "skeleton"
        }
    }
}
