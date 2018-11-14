//
//  RectProgressNode.swift
//  TVTank
//
//  Created by Oliver Klemenz on 17.04.16.
//  Copyright © 2016 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class RectProgressNode : SKNode, ProgressNode {
    
    fileprivate var stopped : Bool = false
    fileprivate var time : CGFloat!
    fileprivate var passedTime : CGFloat! = 0

    fileprivate var width: CGFloat!
    fileprivate var height: CGFloat!
    fileprivate var offsetY: CGFloat!
    fileprivate var cornerRadius: CGFloat!
    
    fileprivate var rectOuter : SKShapeNode!
    fileprivate var rectInner : SKShapeNode!
    
    fileprivate var color : UIColor = UIColor.green
    
    var delegate : ProgressNodeDelegate?
    
    init(time: CGFloat) {
        super.init()
        
        self.time = time
        self.width = 100
        self.height = 5
        self.offsetY = 50
        self.cornerRadius = 5
        self.color = UIColor.green
        
        let rect = CGRect(x: -width / 2.0, y: -offsetY, width: width, height: height)
        
        self.rectOuter = SKShapeNode(rect: rect, cornerRadius: cornerRadius)
        self.rectOuter.fillColor = UIColor.black
        self.rectOuter.strokeColor = UIColor.black
        self.rectOuter.lineWidth = 10
        addChild(self.rectOuter)
        
        self.rectInner = SKShapeNode(rect: rect, cornerRadius: cornerRadius)
        self.rectInner.fillColor = self.color
        self.rectInner.strokeColor = self.color
        self.rectInner.lineWidth = 2
        addChild(self.rectInner)
        
        self.update(0.0, deltaTime: 0.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func ownerNode() -> SKSpriteNode? {
        return parent as? SKSpriteNode
    }
    
    func update(_ currentTime: CFTimeInterval, deltaTime: CFTimeInterval) {
        if stopped {
            return
        }
        passedTime = passedTime + CGFloat(deltaTime)
        let percentage : CGFloat = (passedTime * 1000) / time
        let progress = percentage <= 0.0 ? 1.0 : (percentage >= 1.0 ? 0.0 : 1.0 - percentage)
        let end = width * progress
        self.rectInner.path = UIBezierPath(roundedRect: CGRect(x: -width / 2.0, y: -offsetY, width: end, height: height), cornerRadius:
            self.cornerRadius).cgPath
        updateColor(percentage)
        if percentage >= 1.0 {
            delegate?.didProgressComplete(self)
            stopped = true
        }
    }
    
    func updateColor(_ percentage : CGFloat) {
        if percentage <= 0.25 {
            if !color.isEqual(UIColor.green) {
                colorTransitionAction(color, toColor: UIColor.green)
                color = UIColor.green
            }
        } else if percentage <= 0.5 {
            if !color.isEqual(UIColor.yellow) {
                colorTransitionAction(color, toColor: UIColor.yellow)
                color = UIColor.yellow
            }
        } else if percentage <= 0.75 {
            if !color.isEqual(UIColor.orange) {
                colorTransitionAction(color, toColor: UIColor.orange)
                color = UIColor.orange
            }
        } else if percentage <= 1.0 {
            if !color.isEqual(UIColor.red) {
                colorTransitionAction(color, toColor: UIColor.red)
                color = UIColor.red
            }
        }
    }
    
    func colorTransitionAction(_ fromColor : UIColor, toColor : UIColor, duration : Double = 2.5)  {
        let action = SKAction.customAction(withDuration: duration, actionBlock: { (node : SKNode!, elapsedTime : CGFloat) -> Void in
            var fr = CGFloat(0.0)
            var fg = CGFloat(0.0)
            var fb = CGFloat(0.0)
            var fa = CGFloat(0.0)
            var tr = CGFloat(0.0)
            var tg = CGFloat(0.0)
            var tb = CGFloat(0.0)
            var ta = CGFloat(0.0)
            fromColor.getRed(&fr, green: &fg, blue: &fb, alpha: &fa)
            toColor.getRed(&tr, green: &tg, blue: &tb, alpha: &ta)
            let fraction = CGFloat(elapsedTime / CGFloat(duration))
            let red   = (1.0 - fraction) * fr + fraction * tr
            let green = (1.0 - fraction) * fg + fraction * tg
            let blue  = (1.0 - fraction) * fb + fraction * tb
            let alpha = (1.0 - fraction) * fa + fraction * ta
            let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            self.rectInner.fillColor = color
            self.rectInner.strokeColor = color
            }
        )
        self.run(action)
    }
}
