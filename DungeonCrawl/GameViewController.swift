//
//  GameViewController.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 4/27/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as? SKView else {
            return
        }
        
        if let scene = SKScene(fileNamed: "DungeonScene") {
            view.presentScene(scene)
        }
        
        view.ignoresSiblingOrder = true
        
        view.showsFPS = true
        view.showsNodeCount = true
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
