//
//  Tank.swift
//  TVTank
//
//  Created by Oliver Klemenz on 03.04.16.
//  Copyright © 2016 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

let tankMoveSound = createTankMoveSound()
let tankGunMoveSound = createTankGunMoveSound()

class Tank: SKSpriteNode {

    let GUN_ROTATION_SPEED   : CGFloat = 0.1
    let TANK_ROTATION_SPEED  : CGFloat = 5
    let TANK_BULLET_SPEED    : CGFloat = 1000
    let TANK_MOVE_SPEED      : CGFloat = 300
    let TANK_DUST_BIRTH_RATE : CGFloat = 400
    
    let TANK_EXPLOSION_ZPOS   : CGFloat = -10.0
    let TANK_BODY_ZPOS        : CGFloat = -11.0
    let TANK_BODY_SHADOW_ZPOS : CGFloat = -12.0
    let TANK_DUST_ZPOS        : CGFloat = -13.0

    let TANK_DESTROY_ZPOS     : CGFloat = 1000.0
    let TANK_GUN_ZPOS         : CGFloat = 3.0
    let TANK_BODY_CHAIN_ZPOS  : CGFloat = 2.0
    let TANK_GUN_SHADOW_ZPOS  : CGFloat = 1.0
    
    let TANK_GUN_MOVE_HOLD    = 20
    
    enum MovingDirection {
        case none
        case forwards
        case backwards
    }
    
    enum RotationDirection {
        case none
        case cw
        case ccw
    }
    
    var tankGun: SKSpriteNode!
    var tankChainLeft: SKSpriteNode!
    var tankChainRight: SKSpriteNode!
    var dustEmitterLeft: SKEmitterNode!
    var dustEmitterRight: SKEmitterNode!
    
    var chainLeftAnimationForwards: SKAction!
    var chainLeftAnimationBackwards: SKAction!
    var chainRightAnimationForwards: SKAction!
    var chainRightAnimationBackwards: SKAction!

    var gunShotSound: SKAction!
    var missleShotSound: SKAction!
    var explosionSound: SKAction!
    var tankMoveSoundPlay = false
    var tankGunMoveSoundPlay = 0
    
    var tankGunAngle : CGFloat = 0.0
    var tankMoveSpeed : CGFloat = 0.0
    var tankRotateSpeed : CGFloat = 0.0
    var tankAbsGun : Bool = true
    
    var tankMoving : MovingDirection = MovingDirection.none
    var tankMovingDirection : MovingDirection = MovingDirection.none
    var tankRotating : RotationDirection = RotationDirection.none
    var tankRotatingDirection : RotationDirection = RotationDirection.none
    
    var missileCount = 0
    var destroyed = false
    
    init() {
        self.init(imageNamed:"tank_body")
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
        gunShotSound = SKAction.playSoundFileNamed("gun_shot.caf", waitForCompletion: false)
        missleShotSound = SKAction.playSoundFileNamed("missile_shot.caf", waitForCompletion: false)
        explosionSound = SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false)
        
        texture = SKTexture(imageNamed:"tank_body")
        anchorPoint = CGPoint(x: 0.5, y: 0.4)
        zPosition = TANK_BODY_ZPOS
        position = CGPoint(x: frame.midX, y: frame.midY)
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width - 10.0,
            height: size.height - 25.0))
        physicsBody!.isDynamic = true
        physicsBody!.mass = 20.0
        physicsBody!.restitution = 0.0
        physicsBody!.allowsRotation = true
        physicsBody!.categoryBitMask = CollisionType.tank.rawValue
        physicsBody!.contactTestBitMask = CollisionType.spot.rawValue
        physicsBody!.collisionBitMask = CollisionType.scene.rawValue | CollisionType.obstacle.rawValue |
            CollisionType.box.rawValue
        
        let tankShadow = SKSpriteNode(imageNamed:"tank_body_shadow")
        tankShadow.anchorPoint = CGPoint(x: 0.5, y: 0.4)
        tankShadow.zPosition = TANK_BODY_SHADOW_ZPOS
        tankShadow.alpha = 0.75
        tankShadow.position = CGPoint(x: 4, y: -10)
        addChild(tankShadow)
        
        tankChainLeft = SKSpriteNode(imageNamed:"tank_chain_left_1")
        tankChainLeft.position = CGPoint(x: -38, y: 2.5)
        tankChainLeft.zPosition = TANK_BODY_CHAIN_ZPOS
        addChild(tankChainLeft)
        
        tankChainRight = SKSpriteNode(imageNamed:"tank_chain_right_1")
        tankChainRight.position = CGPoint(x: 38, y: 2.5)
        tankChainRight.zPosition = TANK_BODY_CHAIN_ZPOS
        addChild(tankChainRight)
        
        var tankChainLeftTextures:[SKTexture] = []
        var tankChainRightTextures:[SKTexture] = []
        for i in 1...4 {
            tankChainLeftTextures.append(SKTexture(imageNamed: "tank_chain_left_\(i)"))
            tankChainRightTextures.append(SKTexture(imageNamed: "tank_chain_right_\(i)"))
        }
        chainLeftAnimationForwards = SKAction.repeatForever(
            SKAction.animate(with: tankChainLeftTextures, timePerFrame: 0.05))
        chainLeftAnimationBackwards = chainLeftAnimationForwards.reversed()
        chainRightAnimationForwards = SKAction.repeatForever(
            SKAction.animate(with: tankChainRightTextures, timePerFrame: 0.05))
        chainRightAnimationBackwards = chainRightAnimationForwards.reversed()
        
        tankGun = SKSpriteNode(imageNamed:"tank_gun")
        tankGun.anchorPoint = CGPoint(x: 0.5, y: 0.4)
        tankGun.position = CGPoint(x: 0, y: 0)
        tankGun.zPosition = TANK_GUN_ZPOS
        addChild(tankGun)
        
        let tankGunShadow = SKSpriteNode(imageNamed:"tank_gun_shadow")
        tankGunShadow.anchorPoint = CGPoint(x: 0.5, y: 0.4)
        tankGunShadow.zPosition = TANK_GUN_SHADOW_ZPOS
        tankGunShadow.alpha = 0.5
        tankGunShadow.position = CGPoint(x: 4, y: 6)
        tankGun.addChild(tankGunShadow)
        
        dustEmitterLeft = NSKeyedUnarchiver.unarchiveObject(withFile: Bundle.main.path(forResource: "Dust", ofType: "sks")!) as? SKEmitterNode
        dustEmitterLeft.position = CGPoint(x:-size.width / 2.0 + 10, y:0)
        dustEmitterLeft.name = "dustEmitterLeft"
        dustEmitterLeft.particleZPosition = TANK_DUST_ZPOS
        dustEmitterLeft.targetNode = self
        dustEmitterLeft.particleBirthRate = 0
        addChild(dustEmitterLeft)
        dustEmitterRight = NSKeyedUnarchiver.unarchiveObject(withFile: Bundle.main.path(forResource: "Dust", ofType: "sks")!) as? SKEmitterNode
        dustEmitterRight.position = CGPoint(x:size.width / 2.0 - 10, y:0)
        dustEmitterRight.name = "dustEmitterRight"
        dustEmitterRight.particleZPosition = TANK_DUST_ZPOS
        dustEmitterRight.targetNode = self
        dustEmitterRight.particleBirthRate = 0
        addChild(dustEmitterRight)
    }
    
    func didAddToParent(_ parent:SKNode) {
        dustEmitterLeft.targetNode = parent
        dustEmitterRight.targetNode = parent
    }
    
    func moveTank(_ value: CGFloat) {
        if destroyed {
            return
        }
        
        tankMoveSpeed = (value + 0.5)
        if tankMoveSpeed > 0.1 {
            tankMovingDirection = MovingDirection.forwards
        } else if tankMoveSpeed < -0.1 {
            tankMovingDirection = MovingDirection.backwards
        } else {
            tankMoveSpeed = 0
            tankMovingDirection = MovingDirection.none
        }
        physicsBody!.velocity =
            CGVector(dx:cos(zRotation + .pi / 2) * tankMoveSpeed * TANK_MOVE_SPEED,
                     dy:sin(zRotation + .pi / 2) * tankMoveSpeed * TANK_MOVE_SPEED)
    }
    
    func rotateTank(_ value: CGFloat) {
        if destroyed {
            return
        }
        
        tankRotateSpeed = value
        if tankRotateSpeed > 0.05 {
            tankRotatingDirection = RotationDirection.cw
        } else if tankRotateSpeed < -0.05 {
            tankRotatingDirection = RotationDirection.ccw
        } else {
            tankRotateSpeed = 0
            tankRotatingDirection = RotationDirection.none
        }
        physicsBody!.angularVelocity = tankRotateSpeed * TANK_ROTATION_SPEED
    }
    
    func rotateTankGun(_ x: Float, y: Float) {
        if destroyed {
            return
        }
        
        if x == 0.0 && y == 0.0 {
            tankGunAngle = 0.0
        } else {
            // atan2(x, y) => rotate to landscape
            tankGunAngle = CGFloat(-atan2(-y, x))
        }
    }
    
    func shoot() {
        if destroyed {
            return
        }
        
        if missileCount > 0 {
            shootMissile()
            missileCount -= 1
            if missileCount <= 0 {
                missileCount = 0
                if let level = self.parent as? Level {
                    level.hud.bulletSelected()
                }
            }
        } else {
            shootBullet()
        }
    }
    
    func shootBullet() {
        if destroyed {
            return
        }
        
        let angle = zRotation + tankGun.zRotation + .pi / 2
        
        let bullet = Bullet()
        bullet.position = CGPoint(x: position.x + cos(angle) * size.width / 2.0,
                                  y: position.y + sin(angle) * size.height / 2.0)
        bullet.physicsBody!.velocity =
            CGVector(dx:cos(angle) * TANK_BULLET_SPEED, dy:sin(angle) * TANK_BULLET_SPEED)
        parent!.addChild(bullet)
        bullet.didAddToParent(parent!)
        
        run(gunShotSound)
        
        let gunExplosion =
            NSKeyedUnarchiver.unarchiveObject(withFile: Bundle.main.path(forResource: "Explosion", ofType: "sks")!) as! SKEmitterNode
        gunExplosion.name = "gunExplosion"
        gunExplosion.particleZPosition = TANK_EXPLOSION_ZPOS
        gunExplosion.targetNode = parent
        gunExplosion.particleBirthRate = 500
        gunExplosion.position = CGPoint(x: position.x + cos(angle) * (size.width + 70) / 2.0,
                                        y: position.y + sin(angle) * (size.height + 70) / 2.0)
        parent!.addChild(gunExplosion)
        parent!.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.run({
                gunExplosion.particleBirthRate = 0
            }),
            SKAction.wait(forDuration: 5.0),
            SKAction.run({
                gunExplosion.removeFromParent()
            }),
        ]))
    }
    
    func shootMissile() {
        if destroyed {
            return
        }
        
        let angle = zRotation + tankGun.zRotation + .pi / 2
        
        let missile = Missile()
        missile.position = CGPoint(x: position.x + cos(angle) * size.width / 2.0,
                                  y: position.y + sin(angle) * size.height / 2.0)
        missile.zRotation = zRotation + tankGun.zRotation
        missile.physicsBody!.velocity =
            CGVector(dx:cos(angle) * TANK_BULLET_SPEED, dy:sin(angle) * TANK_BULLET_SPEED)
        parent!.addChild(missile)
        missile.didAddToParent(parent!)
        
        run(gunShotSound)
        run(missleShotSound)
        
        let gunExplosion =
            NSKeyedUnarchiver.unarchiveObject(withFile: Bundle.main.path(forResource: "Explosion", ofType: "sks")!) as! SKEmitterNode
        gunExplosion.name = "gunExplosion"
        gunExplosion.particleZPosition = TANK_EXPLOSION_ZPOS
        gunExplosion.targetNode = parent
        gunExplosion.particleBirthRate = 500
        gunExplosion.position = CGPoint(x: position.x + cos(angle) * (size.width + 70) / 2.0,
                                        y: position.y + sin(angle) * (size.height + 70) / 2.0)
        parent!.addChild(gunExplosion)
        parent!.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.run({
                gunExplosion.particleBirthRate = 0
            }),
            SKAction.wait(forDuration: 5.0),
            SKAction.run({
                gunExplosion.removeFromParent()
            }),
        ]))
    }
        
    func update(_ currentTime: CFTimeInterval, deltaTime: CFTimeInterval) {
        if destroyed {
            return
        }
        
        // Gun
        var absTankGunAngle = tankGunAngle
        if tankAbsGun && tankGunAngle != 0 {
            absTankGunAngle -= zRotation
            if absTankGunAngle > .pi {
                absTankGunAngle -= 2 * .pi
            } else if absTankGunAngle < -.pi {
                absTankGunAngle += 2 * .pi
            }
        }
        var diffGunAngle = absTankGunAngle - tankGun.zRotation
        if diffGunAngle > .pi || diffGunAngle < -.pi {
            diffGunAngle = -diffGunAngle
        }
        diffGunAngle = min(diffGunAngle, GUN_ROTATION_SPEED)
        diffGunAngle = max(diffGunAngle, -GUN_ROTATION_SPEED)
        let tankGunRotationZ = tankGun.zRotation
        var newTankGunRotationZ = tankGunRotationZ + diffGunAngle
        if newTankGunRotationZ > .pi {
            newTankGunRotationZ -= 2 * .pi
        } else if newTankGunRotationZ < -.pi {
            newTankGunRotationZ += 2 * .pi
        }
        let tankGunRotating = abs(diffGunAngle) > 0.05
        tankGun.zRotation = newTankGunRotationZ
        
        // Chains
        let tankMoving = tankMovingDirection != MovingDirection.none
        let tankRotating = !tankMoving && tankRotatingDirection != RotationDirection.none
        if (!tankMoving && !tankRotating) ||
            (tankMoving && self.tankMoving != tankMovingDirection) ||
            (tankRotating && self.tankRotating != tankRotatingDirection) {
            tankChainLeft.removeAllActions()
            tankChainRight.removeAllActions()
            dustEmitterLeft.particleBirthRate = 0
            dustEmitterRight.particleBirthRate = 0
            self.tankMoving = MovingDirection.none
            self.tankRotating = RotationDirection.none
        }
        if tankMoving && self.tankMoving != tankMovingDirection {
            if tankMovingDirection == MovingDirection.forwards {
                tankChainLeft.run(chainLeftAnimationForwards)
                tankChainRight.run(chainRightAnimationForwards)
                dustEmitterLeft.position = CGPoint(x:dustEmitterLeft.position.x, y:-size.height / 2.0 + 15)
                dustEmitterLeft.particleBirthRate = TANK_DUST_BIRTH_RATE
                dustEmitterRight.position = CGPoint(x:dustEmitterRight.position.x, y:-size.height / 2.0 + 15)
                dustEmitterRight.particleBirthRate = TANK_DUST_BIRTH_RATE
            } else if tankMovingDirection == MovingDirection.backwards {
                tankChainLeft.run(chainLeftAnimationBackwards)
                tankChainRight.run(chainRightAnimationBackwards)
                dustEmitterLeft.position = CGPoint(x:dustEmitterLeft.position.x, y:size.height / 2.0 - 15)
                dustEmitterLeft.particleBirthRate = TANK_DUST_BIRTH_RATE
                dustEmitterRight.position = CGPoint(x:dustEmitterRight.position.x, y:size.height / 2.0 - 15)
                dustEmitterRight.particleBirthRate = TANK_DUST_BIRTH_RATE
            }
            self.tankMoving = tankMovingDirection
        }
        if tankRotating && self.tankRotating != tankRotatingDirection {
            if tankRotatingDirection == RotationDirection.cw {
                tankChainLeft.run(chainLeftAnimationBackwards)
                tankChainRight.run(chainRightAnimationForwards)
                dustEmitterLeft.position = CGPoint(x:dustEmitterLeft.position.x, y:size.height / 2.0 - 15)
                dustEmitterLeft.particleBirthRate = TANK_DUST_BIRTH_RATE
                dustEmitterRight.position = CGPoint(x:dustEmitterRight.position.x, y:-size.height / 2.0 + 15)
                dustEmitterRight.particleBirthRate = TANK_DUST_BIRTH_RATE
            } else if tankRotatingDirection == RotationDirection.ccw {
                tankChainLeft.run(chainLeftAnimationForwards)
                tankChainRight.run(chainRightAnimationBackwards)
                dustEmitterLeft.position = CGPoint(x:dustEmitterLeft.position.x, y:-size.height / 2.0 + 15)
                dustEmitterLeft.particleBirthRate = TANK_DUST_BIRTH_RATE
                dustEmitterRight.position = CGPoint(x:dustEmitterRight.position.x, y:size.height / 2.0 - 15)
                dustEmitterRight.particleBirthRate = TANK_DUST_BIRTH_RATE
            }
            self.tankRotating = tankRotatingDirection
        }
        
        if tankMoving || tankRotating {
            if !tankMoveSoundPlay {
                tankMoveSound.play()
                tankMoveSoundPlay = true
            }
            tankMoveSound.adjustPitch(1.0 + 100 * abs(Float(tankMoveSpeed)))
            tankMoveSound.adjustPitchRate(1.0 + 100 * abs(Float(tankMoveSpeed)))
        } else {
            if tankMoveSoundPlay {
                tankMoveSound.pause()
                tankMoveSoundPlay = false
            }
        }
        
        if tankGunRotating {
            if tankGunMoveSoundPlay == 0 {
                tankGunMoveSound.play()
                tankGunMoveSoundPlay = TANK_GUN_MOVE_HOLD
            }
        } else {
            if tankGunMoveSoundPlay > 0 {
                tankGunMoveSoundPlay -= 1
                if tankGunMoveSoundPlay == 0 {
                    tankGunMoveSound.pause()
                }
            }
        }
    }
    
    func toggleAbsGun() {
        tankAbsGun = !tankAbsGun
    }
    
    func destroy() {
        let tankExplosion =
            NSKeyedUnarchiver.unarchiveObject(withFile: Bundle.main.path(forResource: "BigExplosion", ofType: "sks")!) as! SKEmitterNode
        tankExplosion.name = "tankExplosion"
        tankExplosion.particleZPosition = TANK_DESTROY_ZPOS
        tankExplosion.targetNode = parent
        tankExplosion.particleBirthRate = 2000
        tankExplosion.position = position
        
        parent!.addChild(tankExplosion)
        parent!.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.run({
                tankExplosion.particleBirthRate = 0
            }),
            SKAction.wait(forDuration: 5.0),
            SKAction.run({
                tankExplosion.removeFromParent()
                self.removeFromParent()
            }),
        ]))
        
        run(SKAction.fadeOut(withDuration: 1.0))
        run(explosionSound)
        
        removeFromParent()
        
        tankMoveSound.pause()
        tankMoveSoundPlay = false
        tankGunMoveSound.pause()
        tankGunMoveSoundPlay = 0
        destroyed = true
    }
    
    func pauseGame() {
        tankMoveSound.pause()
        tankMoveSoundPlay = false
        tankGunMoveSound.pause()
        tankGunMoveSoundPlay = 0
    }
}
