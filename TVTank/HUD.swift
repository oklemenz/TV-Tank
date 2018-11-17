//
//  HUD.swift
//  TVTank
//
//  Created by Oliver Klemenz on 27.04.16.
//  Copyright © 2016 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class HUD : SKScene {
    
    var bar : SKShapeNode!
    var boxes : [SKSpriteNode]! = []
    var spots : [SKSpriteNode]! = []
    var bullet : SKSpriteNode!
    var missile : SKSpriteNode!
    
    var boxIndex = 0
    var spotIndex = 0
    
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
        bar.enumerateChildNodes(withName: "box") {
            box, stop in
            box.alpha = 0.5
            self.boxes.append(box as! SKSpriteNode)
        }
        boxes.sort(by: { $0.position.x < $1.position.x })
        bar.enumerateChildNodes(withName: "spot") {
            spot, stop in
            spot.alpha = 0.5
            self.spots.append(spot as! SKSpriteNode)
        }
        spots.sort(by: { $0.position.x < $1.position.x })
        bullet = bar.childNode(withName: "bullet") as? SKSpriteNode
        missile = bar.childNode(withName: "missile") as? SKSpriteNode
        missile.isHidden = true
        
        setupComplete = true
    }
    
    func boxCollected() {
        if boxIndex < boxes.count {
            let box = boxes[boxIndex]
            box.alpha = 1.0
            box.texture = SKTexture(imageNamed:"box_front")
            boxIndex += 1
        }
    }
    
    func boxMissed() {
        if boxIndex < boxes.count {
            let box = boxes[boxIndex]
            let cross = SKSpriteNode(imageNamed: "cross")
            cross.size = CGSize(width: 45, height: 45)
            cross.position = box.position
            cross.zPosition = box.zPosition + 1
            cross.setScale(0.0)
            cross.run(SKAction.scale(to: 1.0, duration: 0.25))
            bar.addChild(cross)
            boxIndex += 1
        }
    }
    
    func spotReached() {
        if spotIndex < spots.count {
            let spot = spots[spotIndex]
            spot.alpha = 1.0
            spotIndex += 1
        }
    }
    
    func spotMissed() {
        if spotIndex < spots.count {
            let spot = spots[spotIndex]
            let cross = SKSpriteNode(imageNamed: "cross")
            cross.size = CGSize(width: 45, height: 45)
            cross.position = spot.position
            cross.zPosition = spot.zPosition + 1
            cross.setScale(0.0)
            cross.run(SKAction.scale(to: 1.0, duration: 0.25))
            bar.addChild(cross)
            spotIndex += 1
        }
    }
    
    func bulletSelected() {
        bullet.isHidden = false
        missile.isHidden = true
    }
    
    func missileSelected() {
        bullet.isHidden = true
        missile.isHidden = false
    }
    
}
