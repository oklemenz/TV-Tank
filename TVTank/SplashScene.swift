//
//  SplashScene.swift
//  TVTank
//
//  Created by Oliver Klemenz on 21.05.20.
//  Copyright © 2020 Klemenz, Oliver. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var lastUpdateTime : TimeInterval = 0
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }    
}
