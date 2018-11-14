//
//  CircularProgressNode.swift
//  TVTank
//
//  Created by Oliver Klemenz on 17.04.16.
//  Copyright © 2016 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

class CircularProgressNode : SKNode, ProgressNode {

    fileprivate var stopped : Bool = false
    fileprivate var time : CGFloat!
    fileprivate var passedTime : CGFloat! = 0
    fileprivate var radius: CGFloat!
    fileprivate var startAngle: CGFloat! = .pi / 2
    
    fileprivate var circleOuter : SKShapeNode!
    fileprivate var circleInner : SKShapeNode!
    
    fileprivate var color : UIColor = UIColor.green
    
    var delegate : ProgressNodeDelegate?
    
    init(time: CGFloat) {
        super.init()
        
        self.time = time
        self.radius = 50
        self.color = UIColor.green
        
        self.circleOuter = SKShapeNode(circleOfRadius: self.radius)
        self.circleOuter.strokeColor = UIColor.black
        self.circleOuter.lineWidth = 12
        addChild(self.circleOuter)
        
        self.circleInner = SKShapeNode(circleOfRadius: self.radius)
        self.circleInner.strokeColor = self.color
        self.circleInner.lineWidth = 6
        addChild(self.circleInner)
        
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
        let endAngle = self.startAngle + progress * CGFloat(2.0 * .pi)
        self.circleInner.path = UIBezierPath(arcCenter: CGPoint.zero, radius: self.radius,
                                             startAngle: self.startAngle, endAngle: endAngle, clockwise: true).cgPath
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
                self.circleInner.strokeColor = color
            }
        )
        self.run(action)
    }
}
