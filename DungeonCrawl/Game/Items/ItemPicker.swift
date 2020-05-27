//
//  ItemPicker.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/27/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

typealias ItemPickerOdds = (Item, UInt)

class ItemPicker {
    
    /// Returns a list of tuples containing an item and the cumulative chance that each should be selected.
    /// - Parameter items: List of tuples containing an item and the individual chance the item should be selected.
    /// - Returns: List of tuples containing an item and the cumulative chance the item should be selected.
    ///
    /// - Note:
    /// Given the following input:
    /// `[(dagger, 20), (sword, 50), (greatAxe, 30)]`
    ///
    /// The output will be:
    /// `[(dagger, 20), (sword, 70), (greatAxe, 100)]`
    ///
    /// The final cumulutive chance must equal 100.
    ///
    static func accumulatedOdds(for items: [ItemPickerOdds]) -> [ItemPickerOdds] {
        var accumulator: UInt = 0
        let accumulatedOdds: [ItemPickerOdds] = items.map { (item, itemChance) in
            accumulator += itemChance
            return (item, accumulator)
        }
        assert(accumulator==100, "Chance of choosing items do not equal 100 percent.")
        return accumulatedOdds
    }

    /// Randomly selects an item from a list of item and percent chance tuples.
    /// - Parameter items: List of tuples containing an item and the cumulative chance the item should be selected.
    /// - Returns: The selected item.
    ///
    /// - Note:
    /// The items array must have the cumulative chance in ascending order. The final item's chance must equal 100.
    ///
    /// The following example would have a 20% chance of choosing a dagger, 50% chance of choosing a sword,
    /// and a 30% chance of choosing a great axe.
    ///
    /// `[(dagger, 20), (sword, 70), (greatAxe, 100)]`
    ///
    static func choose(from items: [ItemPickerOdds], d100: D100) -> Item {
        let percent = d100.roll()
        guard let item = items.first(where: { percent <= $0.1 }) else {
            fatalError("Unable to choose item")
        }
        return item.0
    }
}
