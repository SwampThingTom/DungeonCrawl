//
//  GridRect+CoreGraphics.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 4/28/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import CoreGraphics
import Foundation

extension GridRect {
    
    var cgrect: CGRect {
        CGRect(x: CGFloat(origin.x),
               y: CGFloat(origin.y),
               width: CGFloat(size.width),
               height: CGFloat(size.height))
    }
    
    init(rect: CGRect) {
        origin = GridPoint(x: Int(rect.origin.x), y: Int(rect.origin.y))
        size = GridSize(width: Int(rect.size.width), height: Int(rect.size.height))
    }
    
    func intersects(_ rect2: GridRect) -> Bool {
        return cgrect.intersects(rect2.cgrect)
    }
}
