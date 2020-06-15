//
//  Common.swift
//  TVTank
//
//  Created by Oliver Klemenz on 03.04.16.
//  Copyright © 2016 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

enum CollisionType: UInt32 {
    case scene    = 1
    case tank     = 2
    case bullet   = 4
    case missile  = 8
    case obstacle = 16
    case box      = 32
    case spot     = 64
    case ammo     = 128
}

func generateTiledTexture(size: CGSize, imageNamed imageName: String) -> SKTexture? {
    var texture: SKTexture?
    UIGraphicsBeginImageContext(size)
    let context = UIGraphicsGetCurrentContext()
    if let image = UIImage(named: imageName), let cgImage = image.cgImage {
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height), byTiling: true)
        if let tiledImage = UIGraphicsGetImageFromCurrentImageContext() {
            texture = SKTexture(image: tiledImage)
        }
    }
    UIGraphicsEndImageContext()
    return texture
}
