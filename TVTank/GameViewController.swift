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
#if !os(tvOS)
import CoreMotion
#endif

class GameViewController: UIViewController, UIGestureRecognizerDelegate {
    
    #if os(tvOS)
    let PAN_BIAS : CGFloat = 200
    #else
    let PAN_BIAS : CGFloat = 25
    #endif
    
    var splash: SKScene!
    var menu: Menu!
    var level: Level?
    
    var splashActive = false
    var menuActive = false
    var menuControlsActive = false
    var gameActive = false
    
    var gameController : GCController!
    
    var leftArrowTapped : UITapGestureRecognizer!
    var rightArrowTapped : UITapGestureRecognizer!
    var upArrowTapped : UITapGestureRecognizer!
    var downArrowTapped : UITapGestureRecognizer!
    var tapGesture: UITapGestureRecognizer!
    var panTouched : UILongPressGestureRecognizer!
    
    var selectTapped : UITapGestureRecognizer!
    var menuTapped : UITapGestureRecognizer!
    var playTapped : UITapGestureRecognizer!
    
    var swipeRight : UISwipeGestureRecognizer!
    var swipeLeft : UISwipeGestureRecognizer!
    var swipeUp : UISwipeGestureRecognizer!
    var swipeDown : UISwipeGestureRecognizer!
    
    var panPos : CGPoint!
    
    var virtualPadSize: CGSize!
    var virtualPadCenter: CGPoint!

    var timer: Timer?
    
    #if !os(tvOS)
    let motion = CMMotionManager()
    #endif
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerSwipes()
        registerForGameControllerNotifications()
        
        splash = SKScene(fileNamed: "splash")
        menu = Menu(fileNamed: "menu")
        #if os(iOS)
        splash.scaleMode = .aspectFit
        menu.scaleMode = .aspectFit
        #endif
        
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.showsPhysics = false
        
        skView.ignoresSiblingOrder = false
        
        leftArrowTapped = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleLeftArrowTapped))
        leftArrowTapped.allowedPressTypes = [NSNumber(value: UIPress.PressType.leftArrow.rawValue as Int)]
        self.view.addGestureRecognizer(leftArrowTapped)
        
        rightArrowTapped = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleRightArrowTapped))
        rightArrowTapped.allowedPressTypes = [NSNumber(value: UIPress.PressType.upArrow.rawValue as Int)]
        self.view.addGestureRecognizer(rightArrowTapped)
        
        upArrowTapped = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleUpArrowTapped))
        upArrowTapped.allowedPressTypes = [NSNumber(value: UIPress.PressType.upArrow.rawValue as Int)]
        upArrowTapped.delegate = self
        self.view.addGestureRecognizer(upArrowTapped)
        
        downArrowTapped = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleDownArrowTapped))
        downArrowTapped.allowedPressTypes = [NSNumber(value: UIPress.PressType.downArrow.rawValue as Int)]
        downArrowTapped.delegate = self
        self.view.addGestureRecognizer(downArrowTapped)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
        panTouched = UILongPressGestureRecognizer(target: self, action: #selector(handlePanTouch))
        panTouched.minimumPressDuration = 0
        panTouched.delegate = self
        self.view.addGestureRecognizer(panTouched)
        
        selectTapped = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleSelectTapped))
        selectTapped.allowedPressTypes = [NSNumber(value: UIPress.PressType.select.rawValue as Int)]
        self.view.addGestureRecognizer(selectTapped)
        
        menuTapped = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleMenuTapped))
        menuTapped.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue as Int)]
        self.view.addGestureRecognizer(menuTapped)
        
        playTapped = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handlePlayTapped))
        playTapped.allowedPressTypes = [NSNumber(value: UIPress.PressType.playPause.rawValue as Int)]
        self.view.addGestureRecognizer(playTapped)
                        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.showMenu) , name: NSNotification.Name(rawValue: "showMenu"), object: nil)
        
        #if os(iOS)
        if motion.isAccelerometerAvailable {
            let queue = OperationQueue()
            motion.startAccelerometerUpdates(to: queue) { (data, err) in
                if let data = data  {
                    self.updateMotion(x: CGFloat(data.acceleration.x) * 1.5, y: CGFloat(data.acceleration.y * 1.5))
                }
            }
        }
        #endif

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
                if let level = self.level, let tank = level.tank {
                    tank.rotateTankGun(xValue, y: yValue)
                }
            }
            
            microGamepad.buttonA.pressedChangedHandler = { (buttonA: GCControllerButtonInput, value:Float, pressed:Bool) -> Void in
                if self.menuActive {
                    return
                }
                if pressed {
                    self.toggleAbsGun()
                }
            }
            
            microGamepad.buttonX.pressedChangedHandler = { (buttonX: GCControllerButtonInput, value:Float, pressed:Bool) -> Void in
                if self.menuActive {
                    return
                }
                if pressed {
                    self.shoot()
                }
            }
        }
        
        if let motion = self.gameController.motion {
            motion.valueChangedHandler = { (motion: GCMotion) -> () in
                self.updateMotion(x: CGFloat(motion.gravity.x), y: CGFloat(motion.gravity.y))
            }
        }
    }
    
    func toggleAbsGun() {
        if let level = self.level, let tank = level.tank {
            tank.toggleAbsGun()
            if tank.tankAbsGun {
                level.showStatusText("Gun Autolock On")
            } else {
                level.showStatusText("Gun Autolock Off")
            }
        }
    }
    
    func shoot() {
        if let level = self.level {
            level.shoot()
        }
    }
    
    func updateMotion(x: CGFloat, y: CGFloat) {
        if let level = self.level, let tank = level.tank {
            tank.rotateTank(y)
            tank.moveTank(x)
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
            case UISwipeGestureRecognizer.Direction.right:
                menu.up()
                break
            case UISwipeGestureRecognizer.Direction.down:
                menu.right()
                break
            case UISwipeGestureRecognizer.Direction.left:
                menu.down()
                break
            case UISwipeGestureRecognizer.Direction.up:
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
        virtualPadSize = CGSize(width: self.view.frame.size.width / 4, height: self.view.frame.size.height / 2)
        virtualPadCenter = CGPoint(x: virtualPadSize.width * 0.5, y: virtualPadSize.height * 1.5)

        splashActive = false
        menuActive = false
        menuControlsActive = false
        let skView = self.view as! SKView
        if GameState.instance.levelPack == menu.levelPack &&
            GameState.instance.level == menu.level &&
            level != nil && !level!.levelEnd && !restart {
            #if os(iOS)
            level?.scaleMode = .aspectFit
            #endif
            skView.presentScene(level!, transition: SKTransition.crossFade(withDuration: 1.0))
            level?.continueGame()
        } else {
            GameState.instance.levelPack = menu.levelPack
            GameState.instance.level = menu.level
            level = Level(fileNamed: "Level_\(GameState.instance.levelPack)_\(String(format: "%02d", GameState.instance.level))")
            #if os(tvOS)
            level?.scaleMode = .aspectFill
            #else
            level?.scaleMode = .aspectFit
            #endif
            skView.presentScene(level!, transition: SKTransition.crossFade(withDuration: 1.0))
        }
        
        gameActive = true
    }
    
    @objc func showMenu() {
        splashActive = false
        gameActive = false
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
    
    @objc func handlePanTouch(_ panGesture: UILongPressGestureRecognizer) {
        if panGesture.state == .began {
            panPos = panGesture.location(in: self.view)
        }
        let currentPanPos = panGesture.location(in: self.view)
        if self.menuActive {
            if panGesture.state == .changed {
                #if os(tvOS)
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
                #else
                if currentPanPos.x - panPos.x >= PAN_BIAS {
                    menu.right()
                    panPos = currentPanPos
                } else if panPos.x - currentPanPos.x >= PAN_BIAS {
                    menu.left()
                    panPos = currentPanPos
                } else if currentPanPos.y - panPos.y >= PAN_BIAS {
                    menu.down()
                    panPos = currentPanPos
                } else if panPos.y - currentPanPos.y >= PAN_BIAS {
                    menu.up()
                    panPos = currentPanPos
                }
                #endif
            }
        } else if self.gameActive {
            if panGesture.state == .began && !(currentPanPos.x <= 1.5 * virtualPadSize.width && currentPanPos.y >= virtualPadSize.height) {
                panPos = nil
            }
            if panPos != nil {
                if let level = self.level, let tank = level.tank {
                    tank.rotateTankGun(-Float(currentPanPos.y - virtualPadCenter.y), y: -Float(currentPanPos.x - virtualPadCenter.x))
                }
                if panGesture.state == .began {
                    hideControls()
                } else if panGesture.state != .changed {
                    showControls()
                }
            }
        }
    }
    
    func hideControls() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            self.level?.controls?.hide()
        }
    }
    
    func showControls() {
        timer?.invalidate()
        timer = nil
        level?.controls?.show()
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
    
    @objc func didTap(_ tapGesture: UITapGestureRecognizer) {
        let tapPos = tapGesture.location(in: self.view)
        if splashActive {
            showMenu()
        } else if menuActive {
            let point = menu.convertPoint(fromView: tapPos)
            menu.setSelectionAtPoint(point)
            handleSelectTapped()
        } else if gameActive {
            if let level = self.level, let _ = level.tank {
                if tapPos.x >= 1.25 * virtualPadSize.width && tapPos.x <= 2 * virtualPadSize.width && tapPos.y >= virtualPadSize.height {
                    showMenu()
                } else if tapPos.x >= 2 * virtualPadSize.width && tapPos.x <= 2.75 * virtualPadSize.width && tapPos.y >= virtualPadSize.height {
                    toggleAbsGun()
                } else if tapPos.x >= 2.75 * virtualPadSize.width && tapPos.y >= virtualPadSize.height {
                    shoot()
                }
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
        
    override func didReceiveMemoryWarning() {
        if !splashActive {
            splash = nil
        }
        super.didReceiveMemoryWarning()
    }
    
    #if os(iOS)
    override var prefersHomeIndicatorAutoHidden: Bool {
      return true
    }
       
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return UIRectEdge.bottom
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeRight
    }
    #endif
    
}
