//
//  Direction+GridPoint.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/9/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import SpriteKit

extension Direction {
    
    static func direction(from origin: CGPoint, to destination: CGPoint) -> Direction? {
        let angle = (destination - origin).angle
        return direction(for: angle)
    }
    
    static func direction(for angle: CGFloat) -> Direction? {
        let degrees = angle.radiansToDegrees()
        switch degrees {
        case -45 ..< 45:
            return .east
        case 45 ..< 135:
            return .south
        case 135 ..< 180, -180 ..< -135:
            return .west
        case -135 ..< -45:
            return .north
        default:
            return nil
        }
    }
}
