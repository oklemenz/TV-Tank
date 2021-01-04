//
//  Controls.swift
//  TVTank-Touch
//
//  Created by Klemenz, Oliver on 29.12.20.
//  Copyright © 2020 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class Controls : SKScene {
    
    var bar : SKShapeNode!
    var aim : SKSpriteNode!
    var menu : SKSpriteNode!
    var lock : SKSpriteNode!
    var shootBullet : SKSpriteNode!
    var shootMissile : SKSpriteNode!
    
    var setupComplete = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func didMove(to view: SKView) {
    }
    
    override func willMove(from view: SKView) {
    }
    
    func setup() {
        if setupComplete {
            return
        }
        bar = self.childNode(withName: "bar") as? SKShapeNode
        aim = bar.childNode(withName: "aim") as? SKSpriteNode
        menu = bar.childNode(withName: "menu") as? SKSpriteNode
        lock = bar.childNode(withName: "lock") as? SKSpriteNode
        shootBullet = bar.childNode(withName: "shoot_bullet") as? SKSpriteNode
        shootMissile = bar.childNode(withName: "shoot_missile") as? SKSpriteNode
        bulletSelected()
        
        setupComplete = true
    }

    func hide() {
        bar.run(SKAction.fadeAlpha(to: 0.0, duration: 0.5))
    }
    
    func show() {
        bar.run(SKAction.fadeAlpha(to: 1.0, duration: 0.5))
    }
    
    func bulletSelected() {
        shootBullet.alpha = 1.0
        shootMissile.alpha = 0.0
    }
    
    func missileSelected() {
        shootBullet.alpha = 0.0
        shootMissile.alpha = 1.0
    }
    
}
