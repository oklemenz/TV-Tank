//
//  Common.swift
//  TVTank
//
//  Created by Oliver Klemenz on 03.04.16.
//  Copyright © 2016 Klemenz, Oliver. All rights reserved.
//

import Foundation

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
