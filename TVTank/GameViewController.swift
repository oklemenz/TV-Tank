//
//  GameViewController.swift
//  ToyTank
//
//  Created by Oliver Klemenz on 27.09.15.
//  Copyright (c) 2015 Oliver Klemenz. All rights reserved.
//

import UIKit
import SpriteKit
import GameController

class GameViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let PAN_BIAS : CGFloat = 200
    
    var splash: SKScene!
    var menu: Menu!
    var level: Level?
    
    var splashActive = false
    var menuActive = false
    var menuControlsActive = false
    
    var gameController : GCController!
    
    var leftArrowTapped : UITapGestureRecognizer!
    var rightArrowTapped : UITapGestureRecognizer!
    var upArrowTapped : UITapGestureRecognizer!
    var downArrowTapped : UITapGestureRecognizer!
    var panTouched : UIPanGestureRecognizer!
    
    var selectTapped : UITapGestureRecognizer!
    var menuTapped : UITapGestureRecognizer!
    var playTapped : UITapGestureRecognizer!
    
    var swipeRight : UISwipeGestureRecognizer!
    var swipeLeft : UISwipeGestureRecognizer!
    var swipeUp : UISwipeGestureRecognizer!
    var swipeDown : UISwipeGestureRecognizer!
    
    var panPos : CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerSwipes()
        registerForGameControllerNotifications()
        
        splash = SKScene(fileNamed: "splash")        
        menu = Menu(fileNamed: "menu")
        
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.showsPhysics = false
        
        skView.ignoresSiblingOrder = false
        
        leftArrowTapped = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleLeftArrowTapped))
        leftArrowTapped.allowedPressTypes = [NSNumber(value: UIPressType.leftArrow.rawValue as Int)]
        self.view.addGestureRecognizer(leftArrowTapped)
        
        rightArrowTapped = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleRightArrowTapped))
        rightArrowTapped.allowedPressTypes = [NSNumber(value: UIPressType.upArrow.rawValue as Int)]
        self.view.addGestureRecognizer(rightArrowTapped)
        
        upArrowTapped = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleUpArrowTapped))
        upArrowTapped.allowedPressTypes = [NSNumber(value: UIPressType.upArrow.rawValue as Int)]
        upArrowTapped.delegate = self
        self.view.addGestureRecognizer(upArrowTapped)
        
        downArrowTapped = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleDownArrowTapped))
        downArrowTapped.allowedPressTypes = [NSNumber(value: UIPressType.downArrow.rawValue as Int)]
        downArrowTapped.delegate = self
        self.view.addGestureRecognizer(downArrowTapped)
        
        panTouched = UIPanGestureRecognizer(target: self, action: #selector(GameViewController.handlePanTouch))
        panTouched.delegate = self
        self.view.addGestureRecognizer(panTouched)
        
        selectTapped = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleSelectTapped))
        selectTapped.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue as Int)]
        self.view.addGestureRecognizer(selectTapped)
        
        menuTapped = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleMenuTapped))
        menuTapped.allowedPressTypes = [NSNumber(value: UIPressType.menu.rawValue as Int)]
        self.view.addGestureRecognizer(menuTapped)
        
        playTapped = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handlePlayTapped))
        playTapped.allowedPressTypes = [NSNumber(value: UIPressType.playPause.rawValue as Int)]
        self.view.addGestureRecognizer(playTapped)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.showMenu) , name: NSNotification.Name(rawValue: "showMenu"), object: nil)
        
        showSplash()
    }
    
    func registerForGameControllerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleControllerDidConnectNotification(_:)), name: NSNotification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleControllerDidDisconnectNotification(_:)), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
        GCController.startWirelessControllerDiscovery { () }
    }
    
    @objc func handleControllerDidConnectNotification(_ notification: Notification) {
        let connectedGameController = notification.object as! GCController
        let microGamepad = connectedGameController.microGamepad
        if microGamepad != nil {
            self.gameController = connectedGameController
            registerButtons()
        }
    }
    
    @objc func handleControllerDidDisconnectNotification(_ notification: Notification) {
        let disconnectedGameController = notification.object as! GCController
        if disconnectedGameController == self.gameController {
            self.gameController = nil
        }
    }
    
    func registerButtons() {        
        if let microGamepad = self.gameController.microGamepad {
            
            // microGamepad.allowsRotation = true
            microGamepad.reportsAbsoluteDpadValues = true
            
            microGamepad.dpad.valueChangedHandler = { (dpad: GCControllerDirectionPad, xValue: Float, yValue: Float) -> Void in
                if self.menuActive {
                    return
                }
                if let level = self.level {
                    level.tank.rotateTankGun(xValue, y: yValue)
                }
            }
            
            microGamepad.buttonA.pressedChangedHandler = { (buttonA: GCControllerButtonInput, value:Float, pressed:Bool) -> Void in
                if self.menuActive {
                    return
                }
                if pressed {
                    if let level = self.level {
                        level.tank.toggleAbsGun()
                        if level.tank.tankAbsGun {
                            level.showStatusText("Gun Autolock On")
                        } else {
                            level.showStatusText("Gun Autolock Off")
                        }
                    }
                }
            }
            
            microGamepad.buttonX.pressedChangedHandler = { (buttonX: GCControllerButtonInput, value:Float, pressed:Bool) -> Void in
                if self.menuActive {
                    return
                }
                if pressed {
                    if let level = self.level {
                        level.tank.shoot()
                    }
                }
            }
        }
        
        if let motion = self.gameController.motion {
            motion.valueChangedHandler = { (motion: GCMotion) -> () in
                if let level = self.level {
                    level.tank.rotateTank(CGFloat(motion.gravity.y))
                    level.tank.moveTank(CGFloat(motion.gravity.x))
                }
            }
        }
    }
    
    func registerSwipes() {
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.swiped(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.swiped(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.swiped(_:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)

        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.swiped(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc func swiped(_ gesture: UIGestureRecognizer) {
        if !menuActive || !menuControlsActive {
            return
        }
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                menu.up()
                break
            case UISwipeGestureRecognizerDirection.down:
                menu.right()
                break
            case UISwipeGestureRecognizerDirection.left:
                menu.down()
                break
            case UISwipeGestureRecognizerDirection.up:
                menu.left()
                break
            default:
                break
            }
        }
    }
    
    func showSplash() {
        splashActive = true
        let skView = self.view as! SKView
        skView.presentScene(splash, transition: SKTransition.fade(withDuration: 1.0))
        splash.run(SKAction.sequence([
            SKAction.wait(forDuration: 5.0),
            SKAction.run({ 
                self.showMenu()
            })
        ]))
    }
    
    func showLevel(_ restart : Bool) {
        splashActive = false
        menuActive = false
        menuControlsActive = false
        let skView = self.view as! SKView
        if GameState.instance.levelPack == menu.levelPack &&
            GameState.instance.level == menu.level &&
            level != nil && !level!.levelEnd && !restart {
            skView.presentScene(level!, transition: SKTransition.crossFade(withDuration: 1.0))
            level!.continueGame()
        } else {
            GameState.instance.levelPack = menu.levelPack
            GameState.instance.level = menu.level
            level = Level(fileNamed: "Level_\(GameState.instance.levelPack)_\(String(format: "%02d", GameState.instance.level))")
            level?.scaleMode = .aspectFill
            skView.presentScene(level!, transition: SKTransition.crossFade(withDuration: 1.0))
        }
    }
    
    @objc func showMenu() {
        splashActive = false
        if let level = level {
            level.pauseGame()
        }
        menuActive = true
        menuTapped.isEnabled = false
        let skView = self.view as! SKView
        skView.presentScene(menu, transition: SKTransition.crossFade(withDuration: 1.0))
        menu.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.run({ 
                self.menuControlsActive = true
            })
        ]))
    }
    
    @objc func handleMenuTapped() {
        showMenu()
    }
    
    @objc func handlePlayTapped() {
        if splashActive {
            showMenu()
        } else if menuActive && menuControlsActive {
            menuActive = false
            menuControlsActive = false
            menuTapped.isEnabled = true
            menu.select()
            showLevel(false)
        }
    }
    
    @objc func handleSelectTapped() {
        if splashActive {
            showMenu()
        } else if menuActive && menuControlsActive {
            menuActive = false
            menuControlsActive = false
            menuTapped.isEnabled = true
            menu.select()
            showLevel(true)
        }
    }
    
    @objc func handleUpArrowTapped() {
        if menuActive && menuControlsActive {
            menu.left()
        }
    }
    
    @objc func handleDownArrowTapped() {
        if menuActive && menuControlsActive {
            menu.right()
        }
    }
    
    @objc func handleLeftArrowTapped() {
        if menuActive && menuControlsActive {
            menu.down()
        }
    }
    
    @objc func handleRightArrowTapped() {
        if menuActive && menuControlsActive {
            menu.up()
        }
    }
    
    @objc func handlePanTouch(_ panGesture: UIPanGestureRecognizer) {
        if panGesture.state == .began {
            panPos = panGesture.translation(in: self.view)
        }
        if panGesture.state == .changed {
            let currentPanPos = panGesture.translation(in: self.view)
            if currentPanPos.y - panPos.y >= PAN_BIAS {
                menu.right()
                panPos = currentPanPos
            } else if panPos.y - currentPanPos.y >= PAN_BIAS {
                menu.left()
                panPos = currentPanPos
            } else if currentPanPos.x - panPos.x >= PAN_BIAS {
                menu.up()
                panPos = currentPanPos
            } else if panPos.x - currentPanPos.x >= PAN_BIAS {
                menu.down()
                panPos = currentPanPos
            }
        }
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            switch press.type {
            case .menu:
                if menuActive {
                    super.pressesBegan(presses, with: event)
                }
                break
            default:
                super.pressesBegan(presses, with: event)
            }
        }
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            switch press.type {
            case .menu:
                if menuActive {
                    super.pressesEnded(presses, with: event)
                }
                break
            default:
                super.pressesEnded(presses, with: event)
            }
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        if !splashActive {
            splash = nil
        }
        super.didReceiveMemoryWarning()
    }
}
