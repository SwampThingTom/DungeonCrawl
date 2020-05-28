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
    
    private var decoratedCells = Set<GridCell>()

    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator(),
         chance: ChanceDetermining? = nil) {
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
        self.chance = chance ?? Chance(randomNumberGenerator: randomNumberGenerator)
    }
    
    func decorate(dungeon: DungeonModel) -> DungeonDecorations {
        guard let playerStartCell = playerStartCell(in: dungeon) else {
            fatalError("Unable to place player in dungeon")
        }
        let items = placeTreasure(in: dungeon) + placeItems(in: dungeon)
        let enemies = spawnEnemies(in: dungeon)
        return DungeonDecorations(playerStartCell: playerStartCell,
                                  enemies: enemies,
                                  items: items)
    }

    private func playerStartCell(in dungeon: DungeonModel) -> GridCell? {
        for x in 0 ..< dungeon.map.size.width {
            for y in 0 ..< dungeon.map.size.height {
                let cell = GridCell(x: x, y: y)
                if dungeon.map.tile(at: cell) == .floor {
                    decoratedCells.insert(cell)
                    return cell
                }
            }
        }
        return nil
    }
    
    private func placeTreasure(in dungeon: DungeonModel) -> [ItemModel] {
        let treasure: [ItemModel] = dungeon.rooms.compactMap { room in
            guard chance.one(in: 3) else { return nil }
            let cell = room.bounds.randomWallCell(using: &randomNumberGenerator)
            guard !decoratedCells.contains(cell) else { return nil }
            decoratedCells.insert(cell)
            let gold = Dice(die: D10(), numberOfDice: 5).roll()
            let item = createTreasure(worth: gold)
            return ItemModel(item: item, cell: cell)
        }
        return treasure
    }
    
    private func placeItems(in dungeon: DungeonModel) -> [ItemModel] {
        guard dungeon.rooms.count > 0 else { return [] }
        let items: [ItemModel] = (1...dungeon.rooms.count).compactMap { _ in
            // LATER: When more items are available from randomItem(), only have a 1 in 3 chance of an item per room
            let room = dungeon.rooms.randomElement(using: &randomNumberGenerator)!
            let cell = findEmptyCell { room.bounds.randomCell(using: &randomNumberGenerator) }
            decoratedCells.insert(cell)
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
    
    private func spawnEnemies(in dungeon: DungeonModel) -> [EnemyModel] {
        guard dungeon.rooms.count > 0 else {
            return []
        }
        let room = dungeon.rooms.randomElement(using: &randomNumberGenerator)!
        let cell = findEmptyCell { room.bounds.randomCell(using: &randomNumberGenerator) }
        decoratedCells.insert(cell)
        let enemy = EnemyModel(enemyType: .jellyCube, cell: cell)
        return [enemy]
    }
    
    private func findEmptyCell(randomCell: () -> GridCell) -> GridCell {
        var cell: GridCell
        repeat {
            cell = randomCell()
        } while decoratedCells.contains(cell)
        return cell
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
