//
//  HUDView.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/22/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import UIKit

protocol HUDDelegate: class {
    
    func showInventory()
    func rest()
    func attack()
    func showPlayer()
}

// LATER: Reimplement in SpriteKit
class HUDView: UIView {
    
    weak var hudDelegate: HUDDelegate?
    
    @IBOutlet weak var healthLabel: UILabel?
    @IBOutlet weak var weaponLabel: UILabel?
    @IBOutlet weak var armorLabel: UILabel?
    @IBOutlet weak var goldLabel: UILabel?
    
    @IBAction func showInventory() { hudDelegate?.showInventory() }
    @IBAction func rest() { hudDelegate?.rest() }
    @IBAction func attack() { hudDelegate?.attack() }
    @IBAction func showPlayer() { hudDelegate?.showPlayer() }

}
