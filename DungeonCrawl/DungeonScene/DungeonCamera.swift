//
//  DungeonCamera.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/7/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import SpriteKit

class DungeonCamera: SKCameraNode {
    
    /// Initializes a camera that will follow the given node within the bounds of the map and view.
    convenience init(follow nodeToFollow: SKNode, mapNode: SKNode, viewBounds: CGRect) {
        self.init()
        
        let zero = SKRange(constantValue: 0)
        let followConstraint = SKConstraint.distance(zero, to: nodeToFollow)
        
        let xInset = min(viewBounds.width/2 * xScale, mapNode.frame.width/2)
        let yInset = min(viewBounds.height/2 * xScale, mapNode.frame.height/2)
        let constraintRect = mapNode.frame.insetBy(dx: xInset, dy: yInset)
        
        let xRange = SKRange(lowerLimit: constraintRect.minX, upperLimit: constraintRect.maxX)
        let yRange = SKRange(lowerLimit: constraintRect.minY, upperLimit: constraintRect.maxY)
        let edgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        edgeConstraint.referenceNode = mapNode
        
        constraints = [followConstraint, edgeConstraint]
    }
}
