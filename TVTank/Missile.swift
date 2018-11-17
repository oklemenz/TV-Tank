//
//  Bullet.swift
//  TVTank
//
//  Created by Oliver Klemenz on 03.04.16.
//  Copyright © 2016 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class Missile: SKSpriteNode {
    
    let TANK_MISSILE_ZPOS : CGFloat = 999.0
    
    var missileSmokeEmitter : SKEmitterNode!
    var missileFireEmitter : SKEmitterNode!
    
    init() {
        self.init(imageNamed:"missile")
    }
    
    override init(texture: SKTexture!, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        texture = SKTexture(imageNamed:"missile")
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        zPosition = TANK_MISSILE_ZPOS
        
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 20))
        physicsBody!.isDynamic = true
        physicsBody!.mass = 0.01
        physicsBody!.restitution = 0.5
        physicsBody!.allowsRotation = false
        physicsBody!.usesPreciseCollisionDetection = true
        physicsBody!.categoryBitMask = CollisionType.missile.rawValue
        physicsBody!.contactTestBitMask = CollisionType.scene.rawValue | CollisionType.box.rawValue
        physicsBody!.collisionBitMask = CollisionType.scene.rawValue | CollisionType.tank.rawValue |
            CollisionType.box.rawValue
        
        missileSmokeEmitter = NSKeyedUnarchiver.unarchiveObject(withFile: Bundle.main.path(forResource: "Smoke", ofType: "sks")!) as? SKEmitterNode
        missileSmokeEmitter.position = CGPoint(x:0, y:0)
        missileSmokeEmitter.name = "missileSmokeEmitter"
        missileSmokeEmitter.particleZPosition = TANK_MISSILE_ZPOS
        missileSmokeEmitter.targetNode = self
        missileSmokeEmitter.particleBirthRate = 200
        addChild(missileSmokeEmitter)
        
        missileFireEmitter = NSKeyedUnarchiver.unarchiveObject(withFile: Bundle.main.path(forResource: "Fire", ofType: "sks")!) as? SKEmitterNode
        missileFireEmitter.position = CGPoint(x:0, y:0)
        missileFireEmitter.name = "missileFireEmitter"
        missileFireEmitter.particleZPosition = TANK_MISSILE_ZPOS
        missileFireEmitter.targetNode = self
        missileFireEmitter.particleBirthRate = 200
        addChild(missileFireEmitter)
    }
    
    func didAddToParent(_ parent:SKNode) {
        missileSmokeEmitter.targetNode = parent
        missileFireEmitter.targetNode = parent
    }
    
    func destroy() {
        isHidden = true
        physicsBody = nil
        missileSmokeEmitter.particleBirthRate = 0
        missileFireEmitter.particleBirthRate = 0
        run(SKAction.sequence([
            SKAction.wait(forDuration: 5.0),
            SKAction.removeFromParent()
        ]))
    }
    
    func runAfterDelay(_ delay: TimeInterval, block: @escaping ()->()) {
        let time = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: block)
    }
}
