//
//  GridCell+Math.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/22/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

extension GridCell {
    
    // swiftlint:disable line_length
    
    /// Returns the distance from the current cell to a target cell.
    /// - Parameter cell: The target cell.
    /// - Returns: Distance to target in cell units.
    ///
    /// Result is rounded down to the nearest integer.
    ///
    /// - Note: This method may be inaccurate for large values due to the limitations of IEEE Double forrmat.
    ///
    /// For more information, see:
    /// * [Computing the square root of a 64-bit integer](https://codereview.stackexchange.com/questions/69069/computing-the-square-root-of-a-64-bit-in)
    ///
    /// * [Computing the integer square root of large numbers](https://codereview.stackexchange.com/questions/177923/computing-the-integer-square-root-of-large-numbers)
    ///
    /// * [Newton's Method](https://www.school-for-champions.com/algebra/square_root_approx.htm#.XsffmxNKhR0)
    func distance(to cell: GridCell) -> Int {
        let x = Double(cell.x - self.x)
        let y = Double(cell.y - self.y)
        return Int(sqrt(x * x + y * y))
    }
}
