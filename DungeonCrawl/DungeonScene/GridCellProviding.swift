//
//  GridCellProviding.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/9/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import SpriteKit

protocol GridCellProviding {
    func cell(for position: CGPoint) -> GridCell
    func center(of cell: GridCell) -> CGPoint
}

extension SKTileMapNode: GridCellProviding {
    
    func cell(for position: CGPoint) -> GridCell {
        let x = tileColumnIndex(fromPosition: position)
        let y = tileRowIndex(fromPosition: position)
        return GridCell(x: x, y: y)
    }
    
    func center(of cell: GridCell) -> CGPoint {
        return centerOfTile(atColumn: cell.x, row: cell.y)
    }
    
    func isObstacle(_ cell: GridCell) -> Bool {
        let tile = tileDefinition(atColumn: cell.x, row: cell.y)
        return tile?.userData?.object(forKey: "obstacle") != nil
    }
}

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
