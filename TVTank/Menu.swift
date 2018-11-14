//
//  Menu.swift
//  TVTank
//
//  Created by Oliver Klemenz on 10.04.16.
//  Copyright © 2016 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

var menuMusic = createMenuMusic()

class Menu: SKScene {
    
    let successColor = UIColor(red: 130.0/255.0, green: 140.0/255.0, blue: 51.0/255.0, alpha: 1.0)
    let incompleteColor = UIColor(red: 238.0/255.0, green: 121.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    let failedColor = UIColor(red: 134.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    let activeColor = UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)
    let inactiveColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.0)
    
    var setupComplete = false
    var levelNodes : [SKShapeNode] = []
    
    var levelPack = GameState.instance.levelPack
    var level = GameState.instance.level
    var maxLevel = 0
    
    var menuSelectSound: SKAction!
    var menuNavSound: SKAction!
        
    override func didMove(to view: SKView) {
        setup()
        update()
        menuMusic.play()
    }
    
    override func willMove(from view: SKView) {
        menuMusic.pause()
    }
    
    deinit {
        menuMusic.stop()
    }
    
    func setup() {
        if setupComplete {
            return
        }
        
        menuSelectSound = SKAction.playSoundFileNamed("menu_select.caf", waitForCompletion: false)
        menuNavSound = SKAction.playSoundFileNamed("menu_nav.caf", waitForCompletion: false)
        
        for node in self["level"] {
            levelNodes.append(node as! SKShapeNode)
        }
        
        for level in levelNodes {
            for i in 0..<3 {
                let box = SKSpriteNode(imageNamed:"box_front_missing")
                box.name = "box"
                box.size.width = 35
                box.size.height = 35
                box.position.x = -35 + 35 * CGFloat(i)
                box.position.y = -55
                box.zPosition = 100
                level.addChild(box)
            }
        }
        levelNodes.sort(by: {
            let nodeA = $0.childNode(withName: "id") as! SKLabelNode
            let nodeB = $1.childNode(withName: "id") as! SKLabelNode
            let levelA = Int((nodeA.text! as NSString).intValue)
            let levelB = Int((nodeB.text! as NSString).intValue)
            return levelA < levelB
        })
        
        setupComplete = true
    }
    
    func up() {
        if !setupComplete {
            return
        }
        if level > 10 {
            level -= 10
            updateSelection()
        }
    }
    
    func down() {
        if !setupComplete {
            return
        }
        if level + 10 < maxLevel {
            level += 10
            updateSelection()
        }
    }
    
    func left() {
        if !setupComplete {
            return
        }
        if level > 1 {
            level -= 1
            updateSelection()
        }
    }
    
    func right() {
        if !setupComplete {
            return
        }
        if level < maxLevel {
            level += 1
            updateSelection()
        }
    }
    
    func select() {
        if !setupComplete {
            return
        }
        run(menuNavSound)
    }
    
    func updateSelection() {
        if !setupComplete {
            return
        }
        setSelection(level)
        run(menuSelectSound)
    }
    
    func setSelection(_ level : Int) {
        if !setupComplete {
            return
        }
        for levelNode in levelNodes {
            levelNode.glowWidth = 0.0
        }
        if level >= 1 && level <= levelNodes.count {
            let levelNode = levelNodes[level-1]
            levelNode.glowWidth = 5.0
        }
    }
    
    func update() {
        if !setupComplete {
            return
        }
        maxLevel = 1
        levelPack = GameState.instance.levelPack
        level = GameState.instance.level
        for (index, levelNode) in levelNodes.enumerated() {
            let levelIndex = index + 1
            levelNode.fillColor = inactiveColor
            for case let box as SKSpriteNode in levelNode["box"] {
                box.texture = SKTexture(imageNamed:"box_front_missing")
            }
            if let levelState = GameState.instance.getState(levelIndex) {
                let box = levelState["box"]
                let spot = levelState["spot"]
                let play = levelState["play"]
                if play! > 0 {
                    for i in 0..<box! {
                        if i < levelNode["box"].count {
                            if let box = levelNode["box"][i] as? SKSpriteNode {
                                box.texture = SKTexture(imageNamed:"box_front")
                            }
                        }
                    }
                    if spot! < 3 {
                        levelNode.fillColor = failedColor
                    } else {
                        if levelIndex > maxLevel {
                            maxLevel = levelIndex
                        }
                        if box == 3 {
                            levelNode.fillColor = successColor
                        } else {
                            levelNode.fillColor = incompleteColor
                        }
                    }
                    if spot == 3 {
                        if levelIndex + 1 > maxLevel {
                            maxLevel = levelIndex + 1
                        }
                        if levelIndex + 2 > maxLevel {
                            maxLevel = levelIndex + 2
                        }
                    }
                } else {
                    if levelIndex <= maxLevel {
                        let spot = levelState["spot"]
                        if spot! < 3 {
                            levelNode.fillColor = activeColor
                        }
                    }
                }
                maxLevel = min(maxLevel, GameState.instance.maxLevel)
            }
        }
        setSelection(level)
    }
}
