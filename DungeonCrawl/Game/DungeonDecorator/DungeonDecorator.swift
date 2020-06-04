//
//  DungeonDecorator.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/6/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import Foundation

protocol DungeonDecorating {
    func decorate(dungeon: DungeonModel, questItem: Item?) -> DungeonDecorations
}

class DungeonDecorator: DungeonDecorating {
    
    private var randomNumberGenerator: AnyRandomNumberGenerator
    private let chance: ChanceDetermining
    
    private let enemyPlacer: EnemyPlacing
    private let treasurePlacer: TreasurePlacing
    private let itemPlacer: ItemPlacing
    
    init(randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator(),
         chance: ChanceDetermining? = nil,
         treasurePlacer: TreasurePlacing? = nil,
         itemPlacer: ItemPlacing? = nil,
         enemyPlacer: EnemyPlacing? = nil) {
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
        self.chance = chance ?? Chance(randomNumberGenerator: randomNumberGenerator)
        self.treasurePlacer = treasurePlacer ?? TreasurePlacer(randomNumberGenerator: randomNumberGenerator)
        self.itemPlacer = itemPlacer ?? ItemPlacer(randomNumberGenerator: randomNumberGenerator)
        self.enemyPlacer = enemyPlacer ?? EnemyPlacer(randomNumberGenerator: randomNumberGenerator)
    }
    
    func decorate(dungeon: DungeonModel, questItem: Item? = nil) -> DungeonDecorations {
        let occupiedCells = OccupiedCells()
        guard let playerStartCell = playerStartCell(in: dungeon, occupiedCells: occupiedCells) else {
            fatalError("Unable to place player in dungeon")
        }
        let questItemModel = self.questItemModel(questItem, in: dungeon, occupiedCells: occupiedCells)
        let questItems = questItemModel != nil ? [questItemModel!] : []
        let treasure = treasurePlacer.placeTreasure(in: dungeon, occupiedCells: occupiedCells)
        let items = itemPlacer.placeItems(in: dungeon, occupiedCells: occupiedCells)
        let enemies = enemyPlacer.placeEnemies(in: dungeon,
                                               occupiedCells: occupiedCells,
                                               maxChallengeRating: 0.25)
        let allItems = items + treasure + questItems
        return DungeonDecorations(playerStartCell: playerStartCell,
                                  enemies: enemies,
                                  items: allItems)
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
    
    private func questItemModel(_ questItem: Item?,
                                in dungeon: DungeonModel,
                                occupiedCells: OccupiedCells) -> ItemModel? {
        guard let questItem = questItem else { return nil }
        for x in stride(from: dungeon.map.size.width, to: 0, by: -1) {
            for y in stride(from: dungeon.map.size.height, to: 0, by: -1) {
                let cell = GridCell(x: x, y: y)
                if dungeon.map.tile(at: cell) == .floor && !occupiedCells.isOccupied(cell: cell) {
                    occupiedCells.occupy(cell: cell)
                    return ItemModel(item: questItem, cell: cell)
                }
            }
        }
        return nil
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
