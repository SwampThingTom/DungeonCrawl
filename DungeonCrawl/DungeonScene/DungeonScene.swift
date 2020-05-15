//
//  DungeonScene.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/5/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GameSettings {
    static let turnDuration: TimeInterval = 0.5
}

protocol DungeonSceneDisplaying {
}

class DungeonScene: SKScene {
    
    private let tileSize = CGSize(width: 32, height: 32)
    private var tileSet: SKTileSet!
    private var tileMap: SKTileMapNode!
    private var playerSprite = PlayerSprite()
    
    private var game: Game!
    
    private var gameState: DungeonTurnState = .waitingForInput {
        didSet {
            print("gameState is now \(gameState)")
        }
    }
    
    private var playableViewBounds: CGRect {
        guard let view = view else {
            fatalError("Unable to get view for DungeonScene")
        }
        let hudHeight: CGFloat = 160.0
        let playableViewSize = CGSize(width: view.bounds.size.width,
                                      height: view.bounds.size.height - hudHeight)
        return CGRect(origin: view.bounds.origin, size: playableViewSize)
    }
    
    override func sceneDidLoad() {
        guard let tileSet = SKTileSet(named: "Dungeon") else {
            fatalError("Unable to load Dungeon tile set")
        }
        self.tileSet = tileSet
        scaleMode = .resizeFill
    }
    
    override func didMove(to view: SKView) {
        game = createGame()
        setupScene(for: game.level)
    }
    
    // MARK: - Player input
    
    private func touchDown(at position: CGPoint) {
    }
    
    private func touchMoved(to position: CGPoint) {
    }
    
    private func touchUp(at position: CGPoint) {
        guard let direction = Direction.direction(from: playerSprite.position, to: position) else {
            fatalError("Unable to calculate direction from \(playerSprite.position) to \(position)")
        }
        let playerCell = tileMap.cell(for: playerSprite.position)
        let targetCell = playerCell.neighbor(direction: direction)
        guard !tileMap.isObstacle(targetCell) else {
            return
        }
        let action = playerAction(for: targetCell, direction: direction)
        takePlayerTurn(action)
    }
    
    private func playerAction(for cell: GridCell, direction: Direction) -> TurnAction {
        if isEnemy(cell) {
            return TurnAction.attack(direction: direction)
        }
        return TurnAction.move(to: cell, direction: direction)
    }
    
    private func isEnemy(_ cell: GridCell) -> Bool {
        for sprite in children {
            let isEnemy = sprite.userData?.object(forKey: "isEnemy") != nil
            if isEnemy && cell == tileMap.cell(for: sprite.position) {
                return true
            }
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchDown(at: touch.location(in: self))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchMoved(to: touch.location(in: self))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchUp(at: touch.location(in: self))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}

// MARK: - Setup

extension DungeonScene {
    
    func createGame() -> Game {
        let dungeonGenerator = DungeonGenerator()
        let dungeonDecorator = DungeonDecorator()
        let dungeonSize = GridSize(width: 25, height: 25)
        let game = Game(dungeonGenerator: dungeonGenerator,
                        dungeonDecorator: dungeonDecorator,
                        dungeonSize: dungeonSize)
        return game
    }
    
    func setupScene(for level: LevelProviding) {
        let tileMap = self.tileMap(for: level.map)
        let playerStartCell = level.player.cell
        let playerStartPosition = tileMap.centerOfTile(atColumn: playerStartCell.x, row: playerStartCell.y)
        let enemies = sprites(for: level.actors, on: tileMap)
        displayScene(tileMap: tileMap, playerStartPosition: playerStartPosition, enemySprites: enemies)
    }
    
    private func tileMap(for map: GridMap) -> SKTileMapNode {
        let tileMap = SKTileMapNode(tileSet: tileSet,
                                    columns: map.size.width,
                                    rows: map.size.height,
                                    tileSize: tileSize)
        for x in 0 ..< map.size.width {
            for y in 0 ..< map.size.height {
                let cell = GridCell(x: x, y: y)
                if let tile = map.tile(at: cell) {
                    tileMap.setCell(cell, to: tile)
                }
            }
        }
        return tileMap
    }
    
    private func sprites(for enemies: [AIActor], on map: SKTileMapNode) -> [SKSpriteNode] {
        let enemySpriteProvider = EnemySpriteProvider()
        return enemies.compactMap { enemy in
            let sprite = enemySpriteProvider.sprite(for: enemy.enemyType)
            sprite?.position = map.centerOfTile(atColumn: enemy.cell.x, row: enemy.cell.y)
            return sprite
        }
    }
    
}

// MARK: - Display Scene

extension DungeonScene {
    
    func displayScene(tileMap: SKTileMapNode, playerStartPosition: CGPoint, enemySprites: [SKSpriteNode]) {
        addTileMap(tileMap)
        addPlayer(position: playerStartPosition)
        addEnemies(enemySprites)
        addCamera()
    }
    
    private func addTileMap(_ tileMap: SKTileMapNode) {
        self.tileMap = tileMap
        addChild(tileMap)
    }
    
    private func addPlayer(position: CGPoint) {
        playerSprite.position = position
        addChild(playerSprite)
    }
    
    private func addEnemies(_ enemySprites: [SKSpriteNode]) {
        for sprite in enemySprites {
            addChild(sprite)
        }
    }
    
    private func addCamera() {
        let camera = DungeonCamera(follow: playerSprite, mapNode: tileMap, viewBounds: playableViewBounds)
        addChild(camera)
        self.camera = camera
    }
}

// MARK: - Take Turn

extension DungeonScene {
    
    func takePlayerTurn(_ playerAction: TurnAction) {
        guard gameState == .waitingForInput else {
            return
        }
        gameState = .takingTurn
        let animations = game.takeTurn(playerAction: playerAction)
        let animationAction = animationActionForTurn(animations: animations)
        run(animationAction)
    }
    
    func displayEndOfTurn() {
        stopAnimations()
        gameState = .waitingForInput
    }
}

// MARK: - Animations

extension DungeonScene {
    
    func animationActionForTurn(animations: [ActorAnimation]) -> SKAction {
        let spriteActions = animations.map { spriteAction(for: $0) }
        let turnAction = SKAction.group(spriteActions)
        let endOfTurnAction = runAtEndOfTurnAction { self.displayEndOfTurn() }
        return SKAction.sequence([turnAction, endOfTurnAction])
    }
    
    func stopAnimations() {
        for node in children {
            guard let sprite = node as? Animatable else { continue }
            sprite.stopAnimation()
        }
    }

    private func spriteAction(for actorAnimation: ActorAnimation) -> SKAction {
        switch actorAnimation.animation {
        case .attack:
            let attackAction1 = SKAction.moveBy(x: 0.0, y: 8.0, duration: GameSettings.turnDuration / 2.0)
            let attackAction2 = SKAction.moveBy(x: 0.0, y: -8.0, duration: GameSettings.turnDuration / 2.0)
            let attackActions = SKAction.sequence([attackAction1, attackAction2])
            let action = SKAction.run(attackActions, onChildWithName: actorAnimation.actor.name)
            return action
            
        case .move(let cell, let heading):
            let position = tileMap.center(of: cell)
            animateSprite(heading: heading, forSpriteNamed: actorAnimation.actor.name)
            let spriteAction = SKAction.move(to: position, duration: GameSettings.turnDuration)
            let action = SKAction.run(spriteAction, onChildWithName: actorAnimation.actor.name)
            return action
        }
    }
    
    private func runAtEndOfTurnAction(_ block: @escaping () -> Void) -> SKAction {
        let waitAction = SKAction.wait(forDuration: GameSettings.turnDuration)
        let endOfTurnAction = SKAction.run(block)
        return SKAction.sequence([waitAction, endOfTurnAction])
    }
    
    private func animateSprite(heading: Direction, forSpriteNamed spriteName: String) {
        guard let sprite = childNode(withName: spriteName) as? Animatable else {
            print("Unable to update heading for sprite named \(spriteName)")
            return
        }
        sprite.heading = heading
        sprite.startAnimation()
    }
}

extension SKTileMapNode {
    
    func setCell(_ cell: GridCell, to tile: Tile) {
        let tileGroup = tileSet.tileGroup(for: tile)
        setTileGroup(tileGroup, forColumn: cell.x, row: cell.y)
    }
}

extension SKTileSet {
    
    func tileGroup(for tile: Tile) -> SKTileGroup {
        switch tile {
        case .wall:
            return wallTileGroup
        case .floor:
            return floorTileGroup
        case .door:
            return doorTileGroup
        }
    }
    
    var wallsTileGroup: SKTileGroup {
        // LATER: use adjacency group rules
        return tileGroup(named: "Walls")
    }
    
    var wallTileGroup: SKTileGroup {
        return tileGroup(named: "Wall")
    }
    
    var floorTileGroup: SKTileGroup {
        return tileGroup(named: "Floor")
    }
    
    var doorTileGroup: SKTileGroup {
        return tileGroup(named: "Door")
    }
    
    func tileGroup(named name: String) -> SKTileGroup {
        guard let tileGroup = self.tileGroups.first(where: { $0.name == name }) else {
            fatalError("Unable to find tile group named \(name)")
        }
        return tileGroup
    }
}

extension EnemyType {
    var spriteName: String {
        switch self {
        case .ghost: return "Ghost"
        }
    }
}
