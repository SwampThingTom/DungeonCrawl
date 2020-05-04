//
//  DungeonGenerator.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 4/27/20.
//  Copyright © 2020 Bayou Games. All rights reserved.
//

import Foundation

protocol DungeonGenerating {
    func generate(size: GridSize) -> DungeonModel
}

class DungeonGenerator: DungeonGenerating {
    
    private let roomAttempts: Int
    private var randomNumberGenerator: AnyRandomNumberGenerator
    private let roomGenerator: RoomGenerator
    private let mazeGenerator: MazeGenerator
    private let regionConnector: RegionConnector
    
    private var map: MutableGridMap = DungeonMap()
    private var regions = Regions()
    private var rooms = [RoomModel]()

    init(roomAttempts: Int = 5,
         randomNumberGenerator: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.roomAttempts = roomAttempts
        self.randomNumberGenerator = AnyRandomNumberGenerator(randomNumberGenerator)
        roomGenerator = RoomGenerator(randomNumberGenerator: randomNumberGenerator)
        mazeGenerator = MazeGenerator(randomNumberGenerator: randomNumberGenerator)
        regionConnector = RegionConnector(randomNumberGenerator: randomNumberGenerator)
    }
    
    func generate(size: GridSize) -> DungeonModel {
        map = DungeonMap(size: size)
        generateRooms()
        generateMazes()
        connectRegions()
        return DungeonModel(map: map, rooms: rooms)
    }
    
    // MARK: Rooms
    
    private func generateRooms() {
        rooms = roomGenerator.generate(gridSize: map.size, attempts: roomAttempts)
        addToMap(rooms: rooms)
    }
    
    private func addToMap(rooms: [RoomModel]) {
        for room in rooms {
            regions.newRegion()
            regions.add(rect: room.bounds)
            map.fillCells(at: room.bounds, with: .floor)
        }
    }
    
    // MARK: Maze
    
    private func generateMazes() {
        mazeGenerator.generate(map: &map, regions: &regions)
    }
    
    private func connectRegions() {
        regionConnector.connect(regions: &regions, in: &map)
    }
}
