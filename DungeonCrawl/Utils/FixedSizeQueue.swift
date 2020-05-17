//
//  FixedSizeQueue.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/16/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

struct FixedSizeQueue<T> {
    
    private let maxSize: Int
    private var queue = [T]()
    private var next: Int = 0
    
    var count: Int {
        return queue.count
    }
    
    var first: T? {
        return !queue.isEmpty ? self[0] : nil
    }
    
    var last: T? {
        return !queue.isEmpty ? self[queue.count-1] : nil
    }
    
    init(maxSize: Int) {
        self.maxSize = maxSize
    }
    
    mutating func push(_ element: T) {
        if queue.count < maxSize {
            queue.append(element)
        } else {
            queue[next] = element
        }
        next = (next + 1) % maxSize
    }
    
    subscript(index: Int) -> T {
        if queue.count < maxSize {
            return queue[index]
        }
        let queueIndex = (next + index) % maxSize
        return queue[queueIndex]
    }
}
