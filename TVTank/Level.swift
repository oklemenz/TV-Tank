//
//  Level.swift
//  TVTank
//
//  Created by Oliver Klemenz on 03.04.16.
//  Copyright © 2016 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

protocol ProgressNode {
    func update(_ currentTime: CFTimeInterval, deltaTime: CFTimeInterval)
    func ownerNode() -> SKSpriteNode?
}

protocol ProgressNodeDelegate {
    func didProgressComplete(_ progressNode : ProgressNode)
}

let levelMusic = createLevelMusic()

extension SKNode {
    class func unarchiveFromFile(_ file : String) -> SKScene? {
        do {
            if let path = Bundle.main.path(forResource: file, ofType: "sks") {
                let sceneData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
                archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
                let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as? SKScene
                archiver.finishDecoding()
                return scene
            }
        } catch {
        }
        return nil
    }
}

class Level: SKScene, SKPhysicsContactDelegate, ProgressNodeDelegate {
    
    let reservedNames = ["background", "tank", "hud"]

    let LEVEL_STATUS_ZPOS     : CGFloat = 999999.0
    let LEVEL_STATUS_S_ZPOS   : CGFloat = 999998.0
    let LEVEL_HUD_ZPOS        : CGFloat = 99999.0
    let LEVEL_BACKGROUND_ZPOS : CGFloat = -1000.0
    let LEVEL_SPOT_ZPOS       : CGFloat = -99.0
    let TANK_EXPLOSION_ZPOS   : CGFloat = -8.0
    let LEVEL_BOX_ZPOS        : CGFloat = -1.0
    let BOX_BREAK_ZPOS        : CGFloat = 999
    let PROGRESS_BREAK_ZPOS   : CGFloat = 1000
    
    let TIME_FACTOR : CGFloat = 1.0
    let BORDER_OFFSET : CGFloat = 25
    
    var setupComplete = false
    var levelEnd = false
    
    var hud : HUD!
    var tank : Tank!
    var statusText : SKLabelNode!
    var statusTextShadow : SKLabelNode!
    var hasTankContact = false
    var progressNodes : [ProgressNode] = []
    
    var boxCollectedSound: SKAction!
    var spotReachedSound: SKAction!
    var spotCollectedSound: SKAction!
    var explosionSound: SKAction!
    var contactSound: SKAction!
    var ammoCollectedSound: SKAction!
    var missSound: SKAction!
    var hideSound: SKAction!
    var levelSuccessSound: SKAction!
    var levelFailedSound: SKAction!
    
    // Quake
    let moveX1 = SKAction.move(by: CGVector(dx: -7, dy: 0), duration:0.05)
    let moveX2 = SKAction.move(by: CGVector(dx: -10, dy: 0), duration:0.05)
    let moveX3 = SKAction.move(by: CGVector(dx: 7, dy: 0), duration:0.05)
    let moveX4 = SKAction.move(by: CGVector(dx: 10, dy: 0), duration:0.05)
    let moveY1 = SKAction.move(by: CGVector(dx: 0, dy: -7), duration:0.05)
    let moveY2 = SKAction.move(by: CGVector(dx: 0, dy: -10), duration:0.05)
    let moveY3 = SKAction.move(by: CGVector(dx: 0, dy: 7), duration:0.05)
    let moveY4 = SKAction.move(by: CGVector(dx: 0, dy: 10), duration:0.05)
    var trembleX : SKAction!
    var trembleY : SKAction!
    
    var boxBreakEmitter : SKEmitterNode!
    
    var deltaTimeStart : CFTimeInterval = -1
    
    var boxCollectedCount = 0
    var spotReachedCount = 0
    var spotMissCount = 0
    
    override func didMove(to view: SKView) {
        setup()
        levelMusic.play()
    }
    
    override func willMove(from view: SKView) {
        levelMusic.pause()
    }
    
    deinit {
        levelMusic.stop()
    }
    
    func setup() {
        if setupComplete {
            return
        }
        
        physicsWorld.speed = 1.0
        physicsWorld.gravity = CGVector(dx: 0.0, dy:0.0)
        physicsWorld.contactDelegate = self
        let border = CGRect(x: -BORDER_OFFSET,
                            y: -BORDER_OFFSET,
                            width: self.frame.width + 2 * BORDER_OFFSET,
                            height: self.frame.height + 2 * BORDER_OFFSET)
        physicsBody = SKPhysicsBody(edgeLoopFrom:border)
        physicsBody!.categoryBitMask = CollisionType.scene.rawValue
        
        boxCollectedSound = SKAction.playSoundFileNamed("box_collected.caf", waitForCompletion: false)
        spotReachedSound = SKAction.playSoundFileNamed("spot_reached.caf", waitForCompletion: false)
        spotCollectedSound = SKAction.playSoundFileNamed("transition2.caf", waitForCompletion: false)
        explosionSound = SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false)
        contactSound = SKAction.playSoundFileNamed("tank_collision.caf", waitForCompletion: false)
        ammoCollectedSound = SKAction.playSoundFileNamed("ammo_collected.caf", waitForCompletion: false)
        missSound = SKAction.playSoundFileNamed("miss.caf", waitForCompletion: false)
        hideSound = SKAction.playSoundFileNamed("transition1.caf", waitForCompletion: false)
        levelSuccessSound = SKAction.playSoundFileNamed("game_success.caf", waitForCompletion: false)
        levelFailedSound = SKAction.playSoundFileNamed("game_end.caf", waitForCompletion: false)
        
        // Find Tank dummy
        var tankPosition = CGPoint(x: self.size.width / 2.0, y: self.size.height / 2.0)
        var tankRotation : CGFloat = 0
        let tank = childNode(withName: "tank")
        if let tank = tank {
            tankPosition = tank.position
            tankRotation = tank.zRotation
            tank.removeFromParent()
        }
        
        // Create real Tank
        self.tank = Tank()
        self.tank.name = "tank"
        self.tank.position = tankPosition
        self.tank.zRotation = tankRotation
        addChild(self.tank)
        self.tank.didAddToParent(self)
                
        let background = self.childNode(withName: "background")
        background?.zPosition = LEVEL_BACKGROUND_ZPOS
        
        hud = SKNode.unarchiveFromFile("hud") as? HUD
        let hudBar = hud.childNode(withName: "bar") as! SKShapeNode
        hudBar.removeFromParent()
        hudBar.zPosition = LEVEL_HUD_ZPOS
        hudBar.position = CGPoint(x: self.size.width / 2.0, y: self.size.height - hudBar.frame.size.height / 2.0)
        addChild(hudBar)
        
        var spotTextures:[SKTexture] = []
        for i in 1...8 {
            spotTextures.append(SKTexture(imageNamed: "spot_\(i)"))
        }
        let spotAnimation = SKAction.repeatForever(
            SKAction.animate(with: spotTextures, timePerFrame: 0.2))
        
        for node in self.children {
            if let node = node as? SKSpriteNode {
                if node.name == nil {
                    print("Node with empty name detected")
                    exit(0)
                }
                if node.name!.hasPrefix("box") {
                    node.zPosition = LEVEL_BOX_ZPOS
                    if let path = bodyPolygonForSprite(node) {
                        node.physicsBody = SKPhysicsBody(polygonFrom: path)
                        node.physicsBody!.isDynamic = true
                        node.physicsBody!.mass = 50
                        node.physicsBody!.restitution = 0.5
                        node.physicsBody!.friction = 2.0
                        node.physicsBody!.linearDamping = 10.0
                        node.physicsBody!.allowsRotation = false
                        node.physicsBody!.categoryBitMask = CollisionType.box.rawValue
                        node.physicsBody!.contactTestBitMask = CollisionType.bullet.rawValue | CollisionType.missile.rawValue
                        node.physicsBody!.collisionBitMask = CollisionType.scene.rawValue | CollisionType.obstacle.rawValue | CollisionType.tank.rawValue | CollisionType.bullet.rawValue
                    }
                    let timeLabel = node.childNode(withName: "time") as? SKLabelNode
                    if let timeLabel = timeLabel {
                        let time = CGFloat((timeLabel.text! as NSString).floatValue)
                        if time > 0 {
                            let progressNode = CircularProgressNode(time: time * TIME_FACTOR)
                            progressNode.delegate = self
                            progressNode.zPosition = PROGRESS_BREAK_ZPOS
                            node.addChild(progressNode)
                            progressNodes.append(progressNode)
                        }
                        timeLabel.removeFromParent()
                    }
                    node.userData = NSMutableDictionary()
                    var linkObject : [String] = []
                    for case let link as SKLabelNode in node["link"] {
                        linkObject.append(contentsOf: link.text!.components(separatedBy: ","))
                        link.removeFromParent()
                    }
                    node.userData?.setValue(linkObject, forKey: "link")
                } else if node.name!.hasPrefix("spot") {
                    node.run(spotAnimation)
                    node.zPosition = LEVEL_SPOT_ZPOS
                    node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2.0 - 10.0)
                    node.physicsBody!.isDynamic = false
                    node.physicsBody!.allowsRotation = false
                    node.physicsBody!.categoryBitMask = CollisionType.spot.rawValue
                    node.physicsBody!.contactTestBitMask = CollisionType.tank.rawValue
                    node.physicsBody!.collisionBitMask = CollisionType.spot.rawValue
                    let timeLabel = node.childNode(withName: "time") as? SKLabelNode
                    if let timeLabel = timeLabel {
                        let time = CGFloat((timeLabel.text! as NSString).floatValue)
                        if time > 0 {
                            let progressNode = RectProgressNode(time: time * TIME_FACTOR)
                            progressNode.delegate = self
                            progressNode.zPosition = PROGRESS_BREAK_ZPOS
                            node.addChild(progressNode)
                            progressNodes.append(progressNode)
                        }
                        timeLabel.removeFromParent()
                    }
                    node.userData = NSMutableDictionary()
                    var linkObject : [String] = []
                    for case let link as SKLabelNode in node["link"] {
                        linkObject.append(contentsOf: link.text!.components(separatedBy: ","))
                        link.removeFromParent()
                    }
                    node.userData?.setValue(linkObject, forKey: "link")
                } else if node.name!.hasPrefix("ammo") {
                    if let path = bodyPolygonForSprite(node) {
                        node.physicsBody = SKPhysicsBody(polygonFrom: path)
                        node.physicsBody!.isDynamic = false
                        node.physicsBody!.allowsRotation = false
                        node.physicsBody!.categoryBitMask = CollisionType.ammo.rawValue
                        node.physicsBody!.contactTestBitMask = CollisionType.tank.rawValue
                        node.physicsBody!.collisionBitMask = CollisionType.ammo.rawValue
                    }
                    let countLabel = node.childNode(withName: "count") as? SKLabelNode
                    if let countLabel = countLabel {
                        let count = Int((countLabel.text! as NSString).intValue)
                        if count > 0 {
                            node.userData = NSMutableDictionary()
                            node.userData?.setValue(count, forKey: "count")
                        }
                        countLabel.removeFromParent()
                    }
                    let timeLabel = node.childNode(withName: "time") as? SKLabelNode
                    if let timeLabel = timeLabel {
                        let time = CGFloat((timeLabel.text! as NSString).floatValue)
                        if time > 0 {
                            let progressNode = CircularProgressNode(time: time * TIME_FACTOR)
                            progressNode.delegate = self
                            progressNode.zPosition = PROGRESS_BREAK_ZPOS
                            progressNode.position = CGPoint(x: -5.0, y: 5.0)
                            node.addChild(progressNode)
                            progressNodes.append(progressNode)
                        }
                        timeLabel.removeFromParent()
                    }
                } else if !reservedNames.contains(node.name!) {
                    let xScale = node.xScale
                    let yScale = node.yScale
                    let zRotation = node.zRotation
                    // Set body when the sprite is not scaled and not rotated
                    node.xScale = 1.0
                    node.yScale = 1.0
                    node.zRotation = 0.0
                    if let path = bodyPolygonForSprite(node) {
                        node.physicsBody = SKPhysicsBody(polygonFrom: path)
                        node.physicsBody!.isDynamic = false
                        if node.name!.contains("loose") {
                            node.physicsBody!.isDynamic = true
                            node.physicsBody!.mass = 50
                            node.physicsBody!.restitution = 0.5
                            node.physicsBody!.friction = 2.0
                            node.physicsBody!.linearDamping = 20.0
                            node.physicsBody!.allowsRotation = true
                        }
                        node.physicsBody!.categoryBitMask = CollisionType.obstacle.rawValue
                        node.physicsBody!.contactTestBitMask = CollisionType.tank.rawValue | CollisionType.bullet.rawValue |
                            CollisionType.missile.rawValue | CollisionType.box.rawValue
                        node.physicsBody!.collisionBitMask = CollisionType.tank.rawValue | 
                            CollisionType.box.rawValue | CollisionType.obstacle.rawValue
                    }
                    // Body is scaled, rotated with the sprite
                    node.xScale = xScale
                    node.yScale = yScale
                    node.zRotation = zRotation
                }
            }
        }
        
        trembleX = SKAction.sequence([moveX1, moveX4, moveX2, moveX3])
        trembleY = SKAction.sequence([moveY1, moveY4, moveY2, moveY3])
        
        boxBreakEmitter = NSKeyedUnarchiver.unarchiveObject(withFile: Bundle.main.path(forResource: "Wood", ofType: "sks")!) as? SKEmitterNode
        boxBreakEmitter.position = CGPoint(x:0, y:0)
        boxBreakEmitter.name = "boxBreakEmitter"
        boxBreakEmitter.particleZPosition = BOX_BREAK_ZPOS
        boxBreakEmitter.targetNode = self
        boxBreakEmitter.particleBirthRate = 0
        addChild(boxBreakEmitter)
        
        setupComplete = true
    }
    
    func showStatusText(_ text : String) {
        if statusText == nil {
            statusText = SKLabelNode()
            statusText.alpha = 0.0
            statusText.fontSize = 50
            statusText.fontName = "HelveticaNeue"
            statusText.fontColor = UIColor.white
            statusText.position = CGPoint(x: self.size.width / 2.0, y: 15)
            statusText.horizontalAlignmentMode = .center
            statusText.zPosition = LEVEL_STATUS_ZPOS
            addChild(statusText)
        }
        if statusTextShadow == nil {
            statusTextShadow = SKLabelNode()
            statusTextShadow.alpha = 0.0
            statusTextShadow.fontSize = 51
            statusTextShadow.fontName = "HelveticaNeue"
            statusTextShadow.fontColor = UIColor.black
            statusTextShadow.position = CGPoint(x: 0, y: 0)
            statusTextShadow.horizontalAlignmentMode = .center
            statusTextShadow.zPosition = LEVEL_STATUS_S_ZPOS
            statusText.addChild(statusTextShadow)
        }
        statusText.text = text
        statusTextShadow.text = text
        statusText.removeAllActions()
        statusText.run(SKAction.sequence([
            SKAction.fadeIn(withDuration: 0.5),
            SKAction.wait(forDuration: 2.0),
            SKAction.fadeOut(withDuration: 0.5),
        ]))
        
    }
    
    func nodeForCategory(_ contact: SKPhysicsContact, categoryBitMask: UInt32) -> SKNode? {
        if contact.bodyA.categoryBitMask == categoryBitMask {
            return contact.bodyA.node as SKNode?
        } else if contact.bodyB.categoryBitMask == categoryBitMask {
            return contact.bodyB.node as SKNode?
        }
        return nil
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bullet = nodeForCategory(contact, categoryBitMask: CollisionType.bullet.rawValue) as? Bullet
        let missile = nodeForCategory(contact, categoryBitMask: CollisionType.missile.rawValue) as? Missile
        let tank = nodeForCategory(contact, categoryBitMask: CollisionType.tank.rawValue) as? Tank
        let box = nodeForCategory(contact, categoryBitMask: CollisionType.box.rawValue)
        let spot = nodeForCategory(contact, categoryBitMask: CollisionType.spot.rawValue)
        let ammo = nodeForCategory(contact, categoryBitMask: CollisionType.ammo.rawValue)
        let obstacle = nodeForCategory(contact, categoryBitMask: CollisionType.obstacle.rawValue)
        
        var weapon : SKNode?
        if let bullet = bullet {
            weapon = bullet
            bullet.destroy()
            if let obstacle = obstacle {
                if obstacle.name!.contains("bullet_destroyable") {
                    obstacle.removeFromParent()
                }
            }
        }
        if let missile = missile {
            if let obstacle = obstacle {
                if obstacle.name!.contains("missile_destroyable") {
                    weapon = missile
                    missile.destroy()
                    obstacle.removeFromParent()
                }
            } else {
                weapon = missile
                missile.destroy()
            }
        }
        
        if let weapon = weapon {
            weaponHit(weapon)
            if let box = box {
                boxCollected(box)
            }
        }
        
        if tank != nil {
            if let spot = spot {
                spotReached(spot)
            } else {
                tankObstacleContact()
            }
        }
        
        if ammo != nil {
            ammoCollected(ammo!)
        }
    }
    
    func weaponHit(_ weapon : SKNode) {
        let explosion = NSKeyedUnarchiver.unarchiveObject(
                        withFile: Bundle.main.path(forResource: "Explosion", ofType: "sks")!) as! SKEmitterNode
        explosion.name = "gunExplosion"
        explosion.particleZPosition = TANK_EXPLOSION_ZPOS
        explosion.targetNode = self
        explosion.particleBirthRate = 500
        explosion.position = weapon.position
        addChild(explosion)
        run(explosionSound)
        
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.run({
                explosion.particleBirthRate = 0
            }),
            SKAction.wait(forDuration: 5.0),
            SKAction.run({
                explosion.removeFromParent()
            }),
            ]))
        for child in self.children {
            child.run(trembleX)
            child.run(trembleY)
        }
    }
    
    func tankObstacleContact() {
        if !hasTankContact {
            hasTankContact = true
            run(contactSound)
            run(SKAction.sequence([
                SKAction.wait(forDuration: 0.5),
                SKAction.run({
                    self.hasTankContact = false
                })
            ]))
        }
    }
    
    func objectRelevant(_ object : SKNode) -> Bool {
        if object.userData!.value(forKey: "collected") != nil {
            return false
        }
        if object.userData!.value(forKey: "missed") != nil {
            return false
        }
        return true
    }
    
    func spotReached(_ spot : SKNode) {
        if !objectRelevant(spot) {
            return
        }
        spot.userData!.setValue("true", forKey: "collected")
        spot.run(spotReachedSound)
        spot.run(spotCollectedSound)
        spot.removeAllChildren()
        spot.run(SKAction.fadeAlpha(to: 0, duration: 0.5))
        spot.run(SKAction.sequence([
            SKAction.scale(by: 200, duration: 1.0),
            SKAction.removeFromParent()
            ]))
        checkLinks(spot)
        spotReachedCount += 1
        hud.spotReached()
        if spotReachedCount == 3 {
            endLevelSuccess()
        } else if spotMissCount > 0 && spotMissCount + spotReachedCount == 3 {
            endLevelFailed()
        }
    }

    func boxCollected(_ box : SKNode) {
        if !objectRelevant(box) {
            return
        }
        box.userData!.setValue("true", forKey: "collected")
        boxBreakEmitter.position = box.position
        run(SKAction.sequence([
            SKAction.wait(forDuration: 1.5),
            self.boxCollectedSound
            ]))
        boxBreakEmitter.particleBirthRate = 300
        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.25),
            SKAction.run({
                self.boxBreakEmitter.particleBirthRate = 0
            })
            ]))
        box.removeFromParent()
        checkLinks(box)
        boxCollectedCount += 1
        hud.boxCollected()
    }
    
    func ammoCollected(_ ammo : SKNode) {
        if !objectRelevant(ammo) {
            return
        }
        ammo.userData!.setValue("true", forKey: "collected")
        tank.missileCount += Int((ammo.userData!.value(forKey: "count")! as AnyObject).int32Value)
        hud.missileSelected()
        run(ammoCollectedSound)
        ammo.removeFromParent()
    }
    
    func objectMissed(_ object : SKSpriteNode) {
        if !objectRelevant(object) {
            return
        }
        object.userData!.setValue("true", forKey: "missed")
        object.run(SKAction.sequence([
            SKAction.scale(to: 0, duration: 0.5),
            SKAction.removeFromParent()
            ]))
        run(missSound)
        run(hideSound)
        if object.physicsBody!.categoryBitMask == CollisionType.spot.rawValue {
            hud.spotMissed()
            spotMissCount += 1
            if spotMissCount > 0 && spotMissCount + spotReachedCount == 3 {
                endLevelFailed()
            }
        } else if object.physicsBody!.categoryBitMask == CollisionType.box.rawValue {
            hud.boxMissed()
        }
    }
    
    func checkLinks(_ object : SKNode) {
        if let userData = object.userData {
            if let link = userData.value(forKey: "link") as? Array<String> {
                for name in link {
                    if let object = childNode(withName: name) as? SKSpriteNode {
                        objectMissed(object)
                    }
                }
            }
        }
    }
    
    func endLevelSuccess() {
        levelEnd = true
        run(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            levelSuccessSound,
            SKAction.wait(forDuration: 1.5),
            SKAction.run({
                GameState.instance.levelCompleted(self.boxCollectedCount)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "showMenu"), object: nil)
            })
        ]))
    }
    
    func endLevelFailed() {
        levelEnd = true
        run(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            levelFailedSound,
            SKAction.wait(forDuration: 2.0),
            SKAction.run({ 
                self.tank.destroy()
            }),
            SKAction.wait(forDuration: 2.5),
            SKAction.run({
                GameState.instance.levelFailed(self.boxCollectedCount, spot: self.spotReachedCount)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "showMenu"), object: nil)
            })
        ]))
    }
    
    func didProgressComplete(_ progressNode : ProgressNode) {
        if let object = progressNode.ownerNode() {
            objectMissed(object)
        }
    }
    
    func pauseGame() {
        deltaTimeStart = -1
        isPaused = true
        tank.pauseGame()
    }
    
    func continueGame() {
        isPaused = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        var deltaTime : CFTimeInterval = 0.0
        if deltaTimeStart != -1 {
            deltaTime = currentTime - deltaTimeStart
        }
        deltaTimeStart = currentTime
        tank.update(currentTime, deltaTime: deltaTime)
        for progressNode in progressNodes {
            progressNode.update(currentTime, deltaTime: deltaTime)
        }
    }
}
