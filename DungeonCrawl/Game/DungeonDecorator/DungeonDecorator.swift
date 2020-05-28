//
//  DungeonDecorator.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/6/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol DungeonDecorating {
    func decorate(dungeon: DungeonModel) -> DungeonDecorations
}

class DungeonDecorator: DungeonDecorating {
    
    private var randomNumberGenerator: AnyRandomNumberGenerator
    private let chance: ChanceDetermining
    
    private let enemyPlacer: EnemyPlacing

    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator(),
         chance: ChanceDetermining? = nil,
         enemyPlacer: EnemyPlacing? = nil) {
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
        self.chance = chance ?? Chance(randomNumberGenerator: randomNumberGenerator)
        self.enemyPlacer = enemyPlacer ?? EnemyPlacer(randomNumberGenerator: randomNumberGenerator)
    }
    
    func decorate(dungeon: DungeonModel) -> DungeonDecorations {
        let occupiedCells = OccupiedCells()
        guard let playerStartCell = playerStartCell(in: dungeon, occupiedCells: occupiedCells) else {
            fatalError("Unable to place player in dungeon")
        }
        let items = placeTreasure(in: dungeon, occupiedCells: occupiedCells) +
            placeItems(in: dungeon, occupiedCells: occupiedCells)
        let enemies = enemyPlacer.placeEnemies(in: dungeon,
                                               occupiedCells: occupiedCells,
                                               maxChallengeRating: 0.25)
        return DungeonDecorations(playerStartCell: playerStartCell,
                                  enemies: enemies,
                                  items: items)
    }

    private func playerStartCell(in dungeon: DungeonModel, occupiedCells: OccupiedCells) -> GridCell? {
        for x in 0 ..< dungeon.map.size.width {
            for y in 0 ..< dungeon.map.size.height {
                let cell = GridCell(x: x, y: y)
                if dungeon.map.tile(at: cell) == .floor {
                    occupiedCells.occupy(cell: cell)
                    return cell
                }
            }
        }
        return nil
    }
    
    private func placeTreasure(in dungeon: DungeonModel, occupiedCells: OccupiedCells) -> [ItemModel] {
        let treasure: [ItemModel] = dungeon.rooms.compactMap { room in
            guard chance.one(in: 3) else { return nil }
            let cell = room.bounds.randomWallCell(using: &randomNumberGenerator)
            guard !occupiedCells.isOccupied(cell: cell) else { return nil }
            occupiedCells.occupy(cell: cell)
            let gold = Dice(die: D10(), numberOfDice: 5).roll()
            let item = createTreasure(worth: gold)
            return ItemModel(item: item, cell: cell)
        }
        return treasure
    }
    
    private func placeItems(in dungeon: DungeonModel, occupiedCells: OccupiedCells) -> [ItemModel] {
        guard dungeon.rooms.count > 0 else { return [] }
        let items: [ItemModel] = (1...dungeon.rooms.count).compactMap { _ in
            // LATER: When more items are available from randomItem(), only have a 1 in 3 chance of an item per room
            let room = dungeon.rooms.randomElement(using: &randomNumberGenerator)!
            let cell = occupiedCells.findEmptyCell { room.bounds.randomCell(using: &randomNumberGenerator) }
            occupiedCells.occupy(cell: cell)
            guard let item = randomItem() else { return nil }
            return ItemModel(item: item, cell: cell)
        }
        return items
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
}

extension GridRect {
    
    func randomCell(using randomNumberGenerator: inout AnyRandomNumberGenerator) -> GridCell {
        let x = gridXRange.randomElement(using: &randomNumberGenerator)!
        let y = gridYRange.randomElement(using: &randomNumberGenerator)!
        return GridCell(x: x, y: y)
    }
    
    func randomWallCell(using randomNumberGenerator: inout AnyRandomNumberGenerator) -> GridCell {
        let wall = Direction.allCases.randomElement(using: &randomNumberGenerator)!
        switch wall {
        case .north:
            let x = gridXRange.randomElement(using: &randomNumberGenerator)!
            return GridCell(x: x, y: gridYRange.min()!)
        case .south:
            let x = gridXRange.randomElement(using: &randomNumberGenerator)!
            return GridCell(x: x, y: gridYRange.max()!)
        case .west:
            let y = gridYRange.randomElement(using: &randomNumberGenerator)!
            return GridCell(x: gridXRange.min()!, y: y)
        case .east:
            let y = gridYRange.randomElement(using: &randomNumberGenerator)!
            return GridCell(x: gridXRange.max()!, y: y)
        }
    }
}
