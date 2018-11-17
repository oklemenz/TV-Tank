//
//  Bullet.swift
//  TVTank
//
//  Created by Oliver Klemenz on 03.04.16.
//  Copyright © 2016 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class Bullet: SKSpriteNode {
    
    let TANK_BULLET_ZPOS : CGFloat = -9.0
    
    var bulletSmokeEmitter : SKEmitterNode!
    
    init() {
        self.init(imageNamed:"bullet")
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
        texture = SKTexture(imageNamed:"bullet")
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        zPosition = TANK_BULLET_ZPOS
        
        physicsBody = SKPhysicsBody(circleOfRadius: 7.5)
        physicsBody!.isDynamic = true
        physicsBody!.mass = 0.01
        physicsBody!.restitution = 0.5
        physicsBody!.allowsRotation = false
        physicsBody!.usesPreciseCollisionDetection = true
        physicsBody!.categoryBitMask = CollisionType.bullet.rawValue
        physicsBody!.contactTestBitMask = CollisionType.scene.rawValue | CollisionType.box.rawValue
        physicsBody!.collisionBitMask = CollisionType.scene.rawValue | CollisionType.tank.rawValue |
            CollisionType.obstacle.rawValue | CollisionType.box.rawValue
        
        bulletSmokeEmitter = NSKeyedUnarchiver.unarchiveObject(withFile: Bundle.main.path(forResource: "Smoke", ofType: "sks")!) as? SKEmitterNode
        bulletSmokeEmitter.position = CGPoint(x:0, y:0)
        bulletSmokeEmitter.name = "bulletSmokeEmitter"
        bulletSmokeEmitter.particleZPosition = TANK_BULLET_ZPOS
        bulletSmokeEmitter.targetNode = self
        bulletSmokeEmitter.particleBirthRate = 200
        addChild(bulletSmokeEmitter)
    }
    
    func didAddToParent(_ parent:SKNode) {
        bulletSmokeEmitter.targetNode = parent
    }
    
    func destroy() {
        isHidden = true
        physicsBody = nil
        bulletSmokeEmitter.particleBirthRate = 0
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
