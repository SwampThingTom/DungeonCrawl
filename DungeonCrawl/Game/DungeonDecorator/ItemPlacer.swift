//
//  ItemPlacer.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/28/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol ItemPlacing {
    
    /// Adds random carryable items to a dungeon.
    func placeItems(in dungeon: DungeonModel, occupiedCells: OccupiedCells) -> [ItemModel]
}

class ItemPlacer: ItemPlacing {
    
    private var randomNumberGenerator: AnyRandomNumberGenerator
    private let itemPicker: () -> Item?
    
    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator(),
         itemPicker: (() -> Item?)? = nil) {
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
        self.itemPicker = itemPicker ?? randomItem
    }
    
    func placeItems(in dungeon: DungeonModel, occupiedCells: OccupiedCells) -> [ItemModel] {
        guard dungeon.rooms.count > 0 else { return [] }
        let items: [ItemModel] = (1...dungeon.rooms.count).compactMap { _ in
            // LATER: When more items are available from randomItem(), only have a 1 in 3 chance of an item per room
            let room = dungeon.rooms.randomElement(using: &randomNumberGenerator)!
            let cell = occupiedCells.findEmptyCell { room.bounds.randomCell(using: &randomNumberGenerator) }
            occupiedCells.occupy(cell: cell)
            guard let item = self.itemPicker() else { return nil }
            return ItemModel(item: item, cell: cell)
        }
        return items
    }
}

private func randomItem() -> Item? {
    switch D20().roll() {
    case 1:
        return Weapons().random()
    case 2:
        return Armor().random()
    default:
        return nil
    }
}
