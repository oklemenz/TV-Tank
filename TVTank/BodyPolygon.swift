//
//  BodyPolygon.swift
//  TVTank
//
//  Created by Oliver Klemenz on 14.04.16.
//  Copyright © 2016 Klemenz, Oliver. All rights reserved.
//

import Foundation
import SpriteKit

/*
 * Generated with
 * http://insyncapp.net/SKPhysicsBodyPathGenerator.html
 */

var bodyPolygons : [String:CGPath?] = [:]

func bodyPolygonForSprite(_ sprite:SKSpriteNode) -> CGPath? {
    if let texture = sprite.texture {
        if texture.description.contains("box") {
            return memoPath("box", sprite: sprite, callback: bodyPolygonForTexture_box)
        } else if texture.description.contains("ammo") {
            return memoPath("ammo", sprite: sprite, callback: bodyPolygonForTexture_ammo)
        } else if texture.description.contains("bush01") {
            return memoPath("bush01", sprite: sprite, callback: bodyPolygonForTexture_bush01)
        } else if texture.description.contains("bush02") {
            return memoPath("bush02", sprite: sprite, callback: bodyPolygonForTexture_bush02)
        } else if texture.description.contains("bush03") {
            return memoPath("bush03", sprite: sprite, callback: bodyPolygonForTexture_bush03)
        } else if texture.description.contains("bush04") {
            return memoPath("bush04", sprite: sprite, callback: bodyPolygonForTexture_bush04)
        } else if texture.description.contains("bush05") {
            return memoPath("bush05", sprite: sprite, callback: bodyPolygonForTexture_bush05)
        } else if texture.description.contains("bush06") {
            return memoPath("bush06", sprite: sprite, callback: bodyPolygonForTexture_bush06)
        } else if texture.description.contains("bush07") {
            return memoPath("bush07", sprite: sprite, callback: bodyPolygonForTexture_bush07)
        } else if texture.description.contains("bush08") {
            return memoPath("bush08", sprite: sprite, callback: bodyPolygonForTexture_bush08)
        } else if texture.description.contains("bush09") {
            return memoPath("bush09", sprite: sprite, callback: bodyPolygonForTexture_bush09)
        } else if texture.description.contains("stone01") {
            return memoPath("stone01", sprite: sprite, callback: bodyPolygonForTexture_stone01)
        } else if texture.description.contains("stone02") {
            return memoPath("stone02", sprite: sprite, callback: bodyPolygonForTexture_stone02)
        } else if texture.description.contains("stone03") {
            return memoPath("stone03", sprite: sprite, callback: bodyPolygonForTexture_stone03)
        } else if texture.description.contains("stone04") {
            return memoPath("stone04", sprite: sprite, callback: bodyPolygonForTexture_stone04)
        } else if texture.description.contains("stone05") {
            return memoPath("stone05", sprite: sprite, callback: bodyPolygonForTexture_stone05)
        } else if texture.description.contains("stone06") {
            return memoPath("stone06", sprite: sprite, callback: bodyPolygonForTexture_stone06)
        } else if texture.description.contains("stone07") {
            return memoPath("stone07", sprite: sprite, callback: bodyPolygonForTexture_stone07)
        } else if texture.description.contains("stone08") {
            return memoPath("stone08", sprite: sprite, callback: bodyPolygonForTexture_stone08)
        } else if texture.description.contains("stone09") {
            return memoPath("stone09", sprite: sprite, callback: bodyPolygonForTexture_stone09)
        } else if texture.description.contains("stone10") {
            return memoPath("stone10", sprite: sprite, callback: bodyPolygonForTexture_stone10)
        } else if texture.description.contains("stone11") {
            return memoPath("stone11", sprite: sprite, callback: bodyPolygonForTexture_stone11)
        } else if texture.description.contains("stone12") {
            return memoPath("stone12", sprite: sprite, callback: bodyPolygonForTexture_stone12)
        }
    }
    return nil
}

func memoPath(_ name:String, sprite:SKSpriteNode, callback: (_ sprite:SKSpriteNode) -> (CGPath?)) -> CGPath? {
    if bodyPolygons[name] == nil {
        bodyPolygons[name] = callback(sprite)
    }
    return bodyPolygons[name]!
}

func bodyPolygonForTexture_box(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 0 - offsetX, y: 59 - offsetY))
    path.addLine(to: CGPoint(x: 40 - offsetX, y: 98 - offsetY))
    path.addLine(to: CGPoint(x: 81 - offsetX, y: 62 - offsetY))
    path.addLine(to: CGPoint(x: 81 - offsetX, y: 46 - offsetY))
    path.addLine(to: CGPoint(x: 40 - offsetX, y: 8 - offsetY))
    path.addLine(to: CGPoint(x: 0 - offsetX, y: 44 - offsetY))
    
    path.closeSubpath()
    return path
}

func bodyPolygonForTexture_ammo(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 8 - offsetX, y: 59 - offsetY))
    path.addLine(to: CGPoint(x: 22 - offsetX, y: 53 - offsetY))
    path.addLine(to: CGPoint(x: 28 - offsetX, y: 60 - offsetY))
    path.addLine(to: CGPoint(x: 38 - offsetX, y: 52 - offsetY))
    path.addLine(to: CGPoint(x: 36 - offsetX, y: 30 - offsetY))
    path.addLine(to: CGPoint(x: 26 - offsetX, y: 20 - offsetY))
    path.addLine(to: CGPoint(x: 16 - offsetX, y: 26 - offsetY))
    path.addLine(to: CGPoint(x: 12 - offsetX, y: 35 - offsetY))
    path.addLine(to: CGPoint(x: 11 - offsetX, y: 40 - offsetY))
    path.addLine(to: CGPoint(x: 7 - offsetX, y: 44 - offsetY))
    path.addLine(to: CGPoint(x: 6 - offsetX, y: 50 - offsetY))
    
    path.closeSubpath()
    return path
}

func bodyPolygonForTexture_bush01(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 104 - offsetX, y: 197 - offsetY))
    path.addLine(to: CGPoint(x: 121 - offsetX, y: 168 - offsetY))
    path.addLine(to: CGPoint(x: 137 - offsetX, y: 177 - offsetY))
    path.addLine(to: CGPoint(x: 140 - offsetX, y: 163 - offsetY))
    path.addLine(to: CGPoint(x: 148 - offsetX, y: 166 - offsetY))
    path.addLine(to: CGPoint(x: 153 - offsetX, y: 140 - offsetY))
    path.addLine(to: CGPoint(x: 188 - offsetX, y: 130 - offsetY))
    path.addLine(to: CGPoint(x: 168 - offsetX, y: 109 - offsetY))
    path.addLine(to: CGPoint(x: 184 - offsetX, y: 91 - offsetY))
    path.addLine(to: CGPoint(x: 157 - offsetX, y: 62 - offsetY))
    path.addLine(to: CGPoint(x: 168 - offsetX, y: 33 - offsetY))
    path.addLine(to: CGPoint(x: 133 - offsetX, y: 47 - offsetY))
    path.addLine(to: CGPoint(x: 121 - offsetX, y: 20 - offsetY))
    path.addLine(to: CGPoint(x: 110 - offsetX, y: 38 - offsetY))
    path.addLine(to: CGPoint(x: 100 - offsetX, y: 27 - offsetY))
    path.addLine(to: CGPoint(x: 91 - offsetX, y: 38 - offsetY))
    path.addLine(to: CGPoint(x: 64 - offsetX, y: 20 - offsetY))
    path.addLine(to: CGPoint(x: 51 - offsetX, y: 53 - offsetY))
    path.addLine(to: CGPoint(x: 44 - offsetX, y: 59 - offsetY))
    path.addLine(to: CGPoint(x: 51 - offsetX, y: 79 - offsetY))
    path.addLine(to: CGPoint(x: 13 - offsetX, y: 93 - offsetY))
    path.addLine(to: CGPoint(x: 45 - offsetX, y: 106 - offsetY))
    path.addLine(to: CGPoint(x: 34 - offsetX, y: 136 - offsetY))
    path.addLine(to: CGPoint(x: 53 - offsetX, y: 144 - offsetY))
    path.addLine(to: CGPoint(x: 62 - offsetX, y: 179 - offsetY))
    path.addLine(to: CGPoint(x: 88 - offsetX, y: 168 - offsetY))
    
    path.closeSubpath()
    return path
}

func bodyPolygonForTexture_bush02(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 121 - offsetX, y: 232 - offsetY))
    path.addLine(to: CGPoint(x: 134 - offsetX, y: 199 - offsetY))
    path.addLine(to: CGPoint(x: 143 - offsetX, y: 207 - offsetY))
    path.addLine(to: CGPoint(x: 151 - offsetX, y: 190 - offsetY))
    path.addLine(to: CGPoint(x: 179 - offsetX, y: 216 - offsetY))
    path.addLine(to: CGPoint(x: 183 - offsetX, y: 161 - offsetY))
    path.addLine(to: CGPoint(x: 217 - offsetX, y: 170 - offsetY))
    path.addLine(to: CGPoint(x: 201 - offsetX, y: 141 - offsetY))
    path.addLine(to: CGPoint(x: 237 - offsetX, y: 121 - offsetY))
    path.addLine(to: CGPoint(x: 203 - offsetX, y: 107 - offsetY))
    path.addLine(to: CGPoint(x: 221 - offsetX, y: 77 - offsetY))
    path.addLine(to: CGPoint(x: 183 - offsetX, y: 83 - offsetY))
    path.addLine(to: CGPoint(x: 191 - offsetX, y: 68 - offsetY))
    path.addLine(to: CGPoint(x: 174 - offsetX, y: 63 - offsetY))
    path.addLine(to: CGPoint(x: 182 - offsetX, y: 39 - offsetY))
    path.addLine(to: CGPoint(x: 152 - offsetX, y: 58 - offsetY))
    path.addLine(to: CGPoint(x: 151 - offsetX, y: 43 - offsetY))
    path.addLine(to: CGPoint(x: 133 - offsetX, y: 56 - offsetY))
    path.addLine(to: CGPoint(x: 129 - offsetX, y: 14 - offsetY))
    path.addLine(to: CGPoint(x: 107 - offsetX, y: 49 - offsetY))
    path.addLine(to: CGPoint(x: 87 - offsetX, y: 30 - offsetY))
    path.addLine(to: CGPoint(x: 83 - offsetX, y: 57 - offsetY))
    path.addLine(to: CGPoint(x: 39 - offsetX, y: 38 - offsetY))
    path.addLine(to: CGPoint(x: 62 - offsetX, y: 72 - offsetY))
    path.addLine(to: CGPoint(x: 33 - offsetX, y: 64 - offsetY))
    path.addLine(to: CGPoint(x: 49 - offsetX, y: 90 - offsetY))
    path.addLine(to: CGPoint(x: 13 - offsetX, y: 84 - offsetY))
    path.addLine(to: CGPoint(x: 46 - offsetX, y: 108 - offsetY))
    path.addLine(to: CGPoint(x: 27 - offsetX, y: 116 - offsetY))
    path.addLine(to: CGPoint(x: 54 - offsetX, y: 124 - offsetY))
    path.addLine(to: CGPoint(x: 9 - offsetX, y: 149 - offsetY))
    path.addLine(to: CGPoint(x: 46 - offsetX, y: 157 - offsetY))
    path.addLine(to: CGPoint(x: 37 - offsetX, y: 196 - offsetY))
    path.addLine(to: CGPoint(x: 77 - offsetX, y: 178 - offsetY))
    path.addLine(to: CGPoint(x: 78 - offsetX, y: 214 - offsetY))
    path.addLine(to: CGPoint(x: 111 - offsetX, y: 189 - offsetY))
    
    path.closeSubpath()
    return path
}

func bodyPolygonForTexture_bush03(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 105 - offsetX, y: 216 - offsetY))
    path.addLine(to: CGPoint(x: 140 - offsetX, y: 211 - offsetY))
    path.addLine(to: CGPoint(x: 140 - offsetX, y: 190 - offsetY))
    path.addLine(to: CGPoint(x: 170 - offsetX, y: 192 - offsetY))
    path.addLine(to: CGPoint(x: 197 - offsetX, y: 149 - offsetY))
    path.addLine(to: CGPoint(x: 209 - offsetX, y: 93 - offsetY))
    path.addLine(to: CGPoint(x: 180 - offsetX, y: 69 - offsetY))
    path.addLine(to: CGPoint(x: 157 - offsetX, y: 70 - offsetY))
    path.addLine(to: CGPoint(x: 138 - offsetX, y: 59 - offsetY))
    path.addLine(to: CGPoint(x: 120 - offsetX, y: 24 - offsetY))
    path.addLine(to: CGPoint(x: 105 - offsetX, y: 40 - offsetY))
    path.addLine(to: CGPoint(x: 91 - offsetX, y: 24 - offsetY))
    path.addLine(to: CGPoint(x: 54 - offsetX, y: 28 - offsetY))
    path.addLine(to: CGPoint(x: 68 - offsetX, y: 55 - offsetY))
    path.addLine(to: CGPoint(x: 36 - offsetX, y: 80 - offsetY))
    path.addLine(to: CGPoint(x: 21 - offsetX, y: 120 - offsetY))
    path.addLine(to: CGPoint(x: 22 - offsetX, y: 135 - offsetY))
    path.addLine(to: CGPoint(x: 58 - offsetX, y: 144 - offsetY))
    path.addLine(to: CGPoint(x: 88 - offsetX, y: 135 - offsetY))
    path.addLine(to: CGPoint(x: 98 - offsetX, y: 149 - offsetY))
    path.addLine(to: CGPoint(x: 69 - offsetX, y: 164 - offsetY))
    path.addLine(to: CGPoint(x: 84 - offsetX, y: 190 - offsetY))
    
    path.closeSubpath()
    return path
}

func bodyPolygonForTexture_bush04(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 105 - offsetX, y: 200 - offsetY))
    path.addLine(to: CGPoint(x: 128 - offsetX, y: 193 - offsetY))
    path.addLine(to: CGPoint(x: 131 - offsetX, y: 181 - offsetY))
    path.addLine(to: CGPoint(x: 157 - offsetX, y: 167 - offsetY))
    path.addLine(to: CGPoint(x: 155 - offsetX, y: 150 - offsetY))
    path.addLine(to: CGPoint(x: 179 - offsetX, y: 138 - offsetY))
    path.addLine(to: CGPoint(x: 185 - offsetX, y: 118 - offsetY))
    path.addLine(to: CGPoint(x: 171 - offsetX, y: 76 - offsetY))
    path.addLine(to: CGPoint(x: 160 - offsetX, y: 51 - offsetY))
    path.addLine(to: CGPoint(x: 121 - offsetX, y: 47 - offsetY))
    path.addLine(to: CGPoint(x: 107 - offsetX, y: 18 - offsetY))
    path.addLine(to: CGPoint(x: 77 - offsetX, y: 28 - offsetY))
    path.addLine(to: CGPoint(x: 65 - offsetX, y: 39 - offsetY))
    path.addLine(to: CGPoint(x: 41 - offsetX, y: 37 - offsetY))
    path.addLine(to: CGPoint(x: 28 - offsetX, y: 52 - offsetY))
    path.addLine(to: CGPoint(x: 22 - offsetX, y: 69 - offsetY))
    path.addLine(to: CGPoint(x: 10 - offsetX, y: 87 - offsetY))
    path.addLine(to: CGPoint(x: 12 - offsetX, y: 108 - offsetY))
    path.addLine(to: CGPoint(x: 8 - offsetX, y: 132 - offsetY))
    path.addLine(to: CGPoint(x: 39 - offsetX, y: 149 - offsetY))
    path.addLine(to: CGPoint(x: 32 - offsetX, y: 183 - offsetY))
    path.addLine(to: CGPoint(x: 47 - offsetX, y: 192 - offsetY))
    path.addLine(to: CGPoint(x: 80 - offsetX, y: 185 - offsetY))
    
    path.closeSubpath()
    return path
}

func bodyPolygonForTexture_bush05(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 77 - offsetX, y: 164 - offsetY))
    path.addLine(to: CGPoint(x: 90 - offsetX, y: 157 - offsetY))
    path.addLine(to: CGPoint(x: 110 - offsetX, y: 161 - offsetY))
    path.addLine(to: CGPoint(x: 106 - offsetX, y: 148 - offsetY))
    path.addLine(to: CGPoint(x: 115 - offsetX, y: 146 - offsetY))
    path.addLine(to: CGPoint(x: 129 - offsetX, y: 160 - offsetY))
    path.addLine(to: CGPoint(x: 134 - offsetX, y: 148 - offsetY))
    path.addLine(to: CGPoint(x: 142 - offsetX, y: 129 - offsetY))
    path.addLine(to: CGPoint(x: 152 - offsetX, y: 125 - offsetY))
    path.addLine(to: CGPoint(x: 148 - offsetX, y: 109 - offsetY))
    path.addLine(to: CGPoint(x: 154 - offsetX, y: 93 - offsetY))
    path.addLine(to: CGPoint(x: 138 - offsetX, y: 74 - offsetY))
    path.addLine(to: CGPoint(x: 152 - offsetX, y: 60 - offsetY))
    path.addLine(to: CGPoint(x: 138 - offsetX, y: 49 - offsetY))
    path.addLine(to: CGPoint(x: 128 - offsetX, y: 53 - offsetY))
    path.addLine(to: CGPoint(x: 115 - offsetX, y: 26 - offsetY))
    path.addLine(to: CGPoint(x: 106 - offsetX, y: 35 - offsetY))
    path.addLine(to: CGPoint(x: 91 - offsetX, y: 21 - offsetY))
    path.addLine(to: CGPoint(x: 81 - offsetX, y: 34 - offsetY))
    path.addLine(to: CGPoint(x: 61 - offsetX, y: 19 - offsetY))
    path.addLine(to: CGPoint(x: 59 - offsetX, y: 37 - offsetY))
    path.addLine(to: CGPoint(x: 50 - offsetX, y: 34 - offsetY))
    path.addLine(to: CGPoint(x: 51 - offsetX, y: 47 - offsetY))
    path.addLine(to: CGPoint(x: 27 - offsetX, y: 50 - offsetY))
    path.addLine(to: CGPoint(x: 31 - offsetX, y: 65 - offsetY))
    path.addLine(to: CGPoint(x: 15 - offsetX, y: 80 - offsetY))
    path.addLine(to: CGPoint(x: 19 - offsetX, y: 96 - offsetY))
    path.addLine(to: CGPoint(x: 21 - offsetX, y: 110 - offsetY))
    path.addLine(to: CGPoint(x: 32 - offsetX, y: 113 - offsetY))
    path.addLine(to: CGPoint(x: 24 - offsetX, y: 128 - offsetY))
    path.addLine(to: CGPoint(x: 40 - offsetX, y: 126 - offsetY))
    path.addLine(to: CGPoint(x: 46 - offsetX, y: 140 - offsetY))
    path.addLine(to: CGPoint(x: 62 - offsetX, y: 137 - offsetY))
    path.addLine(to: CGPoint(x: 61 - offsetX, y: 152 - offsetY))
    path.addLine(to: CGPoint(x: 73 - offsetX, y: 146 - offsetY))
    
    path.closeSubpath()
    return path
}

func bodyPolygonForTexture_bush06(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 79 - offsetX, y: 137 - offsetY))
    path.addLine(to: CGPoint(x: 77 - offsetX, y: 139 - offsetY))
    path.addLine(to: CGPoint(x: 89 - offsetX, y: 126 - offsetY))
    path.addLine(to: CGPoint(x: 97 - offsetX, y: 121 - offsetY))
    path.addLine(to: CGPoint(x: 98 - offsetX, y: 110 - offsetY))
    path.addLine(to: CGPoint(x: 114 - offsetX, y: 109 - offsetY))
    path.addLine(to: CGPoint(x: 109 - offsetX, y: 101 - offsetY))
    path.addLine(to: CGPoint(x: 122 - offsetX, y: 94 - offsetY))
    path.addLine(to: CGPoint(x: 114 - offsetX, y: 81 - offsetY))
    path.addLine(to: CGPoint(x: 123 - offsetX, y: 75 - offsetY))
    path.addLine(to: CGPoint(x: 123 - offsetX, y: 55 - offsetY))
    path.addLine(to: CGPoint(x: 115 - offsetX, y: 43 - offsetY))
    path.addLine(to: CGPoint(x: 110 - offsetX, y: 28 - offsetY))
    path.addLine(to: CGPoint(x: 86 - offsetX, y: 32 - offsetY))
    path.addLine(to: CGPoint(x: 79 - offsetX, y: 33 - offsetY))
    path.addLine(to: CGPoint(x: 80 - offsetX, y: 14 - offsetY))
    path.addLine(to: CGPoint(x: 63 - offsetX, y: 24 - offsetY))
    path.addLine(to: CGPoint(x: 46 - offsetX, y: 18 - offsetY))
    path.addLine(to: CGPoint(x: 44 - offsetX, y: 41 - offsetY))
    path.addLine(to: CGPoint(x: 12 - offsetX, y: 35 - offsetY))
    path.addLine(to: CGPoint(x: 37 - offsetX, y: 56 - offsetY))
    path.addLine(to: CGPoint(x: 10 - offsetX, y: 58 - offsetY))
    path.addLine(to: CGPoint(x: 28 - offsetX, y: 71 - offsetY))
    path.addLine(to: CGPoint(x: 5 - offsetX, y: 96 - offsetY))
    path.addLine(to: CGPoint(x: 35 - offsetX, y: 87 - offsetY))
    path.addLine(to: CGPoint(x: 23 - offsetX, y: 121 - offsetY))
    path.addLine(to: CGPoint(x: 45 - offsetX, y: 105 - offsetY))
    path.addLine(to: CGPoint(x: 43 - offsetX, y: 131 - offsetY))
    path.addLine(to: CGPoint(x: 67 - offsetX, y: 120 - offsetY))
    
    path.closeSubpath()
    return path
}

func bodyPolygonForTexture_bush07(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 131 - offsetX, y: 241 - offsetY))
    path.addLine(to: CGPoint(x: 147 - offsetX, y: 241 - offsetY))
    path.addLine(to: CGPoint(x: 153 - offsetX, y: 227 - offsetY))
    path.addLine(to: CGPoint(x: 189 - offsetX, y: 224 - offsetY))
    path.addLine(to: CGPoint(x: 199 - offsetX, y: 184 - offsetY))
    path.addLine(to: CGPoint(x: 229 - offsetX, y: 165 - offsetY))
    path.addLine(to: CGPoint(x: 194 - offsetX, y: 160 - offsetY))
    path.addLine(to: CGPoint(x: 211 - offsetX, y: 149 - offsetY))
    path.addLine(to: CGPoint(x: 219 - offsetX, y: 133 - offsetY))
    path.addLine(to: CGPoint(x: 232 - offsetX, y: 128 - offsetY))
    path.addLine(to: CGPoint(x: 212 - offsetX, y: 112 - offsetY))
    path.addLine(to: CGPoint(x: 222 - offsetX, y: 69 - offsetY))
    path.addLine(to: CGPoint(x: 184 - offsetX, y: 27 - offsetY))
    path.addLine(to: CGPoint(x: 147 - offsetX, y: 32 - offsetY))
    path.addLine(to: CGPoint(x: 102 - offsetX, y: 21 - offsetY))
    path.addLine(to: CGPoint(x: 80 - offsetX, y: 50 - offsetY))
    path.addLine(to: CGPoint(x: 101 - offsetX, y: 64 - offsetY))
    path.addLine(to: CGPoint(x: 75 - offsetX, y: 64 - offsetY))
    path.addLine(to: CGPoint(x: 74 - offsetX, y: 78 - offsetY))
    path.addLine(to: CGPoint(x: 85 - offsetX, y: 86 - offsetY))
    path.addLine(to: CGPoint(x: 68 - offsetX, y: 84 - offsetY))
    path.addLine(to: CGPoint(x: 56 - offsetX, y: 65 - offsetY))
    path.addLine(to: CGPoint(x: 33 - offsetX, y: 70 - offsetY))
    path.addLine(to: CGPoint(x: 6 - offsetX, y: 98 - offsetY))
    path.addLine(to: CGPoint(x: 20 - offsetX, y: 108 - offsetY))
    path.addLine(to: CGPoint(x: 8 - offsetX, y: 131 - offsetY))
    path.addLine(to: CGPoint(x: 23 - offsetX, y: 143 - offsetY))
    path.addLine(to: CGPoint(x: 47 - offsetX, y: 143 - offsetY))
    path.addLine(to: CGPoint(x: 32 - offsetX, y: 153 - offsetY))
    path.addLine(to: CGPoint(x: 34 - offsetX, y: 168 - offsetY))
    path.addLine(to: CGPoint(x: 21 - offsetX, y: 181 - offsetY))
    path.addLine(to: CGPoint(x: 34 - offsetX, y: 200 - offsetY))
    path.addLine(to: CGPoint(x: 48 - offsetX, y: 201 - offsetY))
    path.addLine(to: CGPoint(x: 56 - offsetX, y: 228 - offsetY))
    path.addLine(to: CGPoint(x: 78 - offsetX, y: 222 - offsetY))
    path.addLine(to: CGPoint(x: 80 - offsetX, y: 208 - offsetY))
    path.addLine(to: CGPoint(x: 100 - offsetX, y: 207 - offsetY))
    path.addLine(to: CGPoint(x: 108 - offsetX, y: 224 - offsetY))
    path.addLine(to: CGPoint(x: 127 - offsetX, y: 232 - offsetY))
    
    path.closeSubpath()
    return path
}

func bodyPolygonForTexture_bush08(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 90 - offsetX, y: 214 - offsetY))
    path.addLine(to: CGPoint(x: 105 - offsetX, y: 216 - offsetY))
    path.addLine(to: CGPoint(x: 124 - offsetX, y: 228 - offsetY))
    path.addLine(to: CGPoint(x: 153 - offsetX, y: 225 - offsetY))
    path.addLine(to: CGPoint(x: 169 - offsetX, y: 209 - offsetY))
    path.addLine(to: CGPoint(x: 199 - offsetX, y: 218 - offsetY))
    path.addLine(to: CGPoint(x: 227 - offsetX, y: 194 - offsetY))
    path.addLine(to: CGPoint(x: 257 - offsetX, y: 178 - offsetY))
    path.addLine(to: CGPoint(x: 263 - offsetX, y: 148 - offsetY))
    path.addLine(to: CGPoint(x: 271 - offsetX, y: 134 - offsetY))
    path.addLine(to: CGPoint(x: 258 - offsetX, y: 107 - offsetY))
    path.addLine(to: CGPoint(x: 265 - offsetX, y: 94 - offsetY))
    path.addLine(to: CGPoint(x: 231 - offsetX, y: 60 - offsetY))
    path.addLine(to: CGPoint(x: 214 - offsetX, y: 34 - offsetY))
    path.addLine(to: CGPoint(x: 178 - offsetX, y: 26 - offsetY))
    path.addLine(to: CGPoint(x: 146 - offsetX, y: 39 - offsetY))
    path.addLine(to: CGPoint(x: 125 - offsetX, y: 43 - offsetY))
    path.addLine(to: CGPoint(x: 101 - offsetX, y: 44 - offsetY))
    path.addLine(to: CGPoint(x: 82 - offsetX, y: 48 - offsetY))
    path.addLine(to: CGPoint(x: 57 - offsetX, y: 60 - offsetY))
    path.addLine(to: CGPoint(x: 53 - offsetX, y: 74 - offsetY))
    path.addLine(to: CGPoint(x: 22 - offsetX, y: 95 - offsetY))
    path.addLine(to: CGPoint(x: 14 - offsetX, y: 112 - offsetY))
    path.addLine(to: CGPoint(x: 24 - offsetX, y: 126 - offsetY))
    path.addLine(to: CGPoint(x: 22 - offsetX, y: 140 - offsetY))
    path.addLine(to: CGPoint(x: 39 - offsetX, y: 148 - offsetY))
    path.addLine(to: CGPoint(x: 25 - offsetX, y: 158 - offsetY))
    path.addLine(to: CGPoint(x: 38 - offsetX, y: 171 - offsetY))
    path.addLine(to: CGPoint(x: 41 - offsetX, y: 187 - offsetY))
    path.addLine(to: CGPoint(x: 62 - offsetX, y: 203 - offsetY))
    
    path.closeSubpath()
    return path
}

func bodyPolygonForTexture_bush09(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 102 - offsetX, y: 363 - offsetY))
    path.addLine(to: CGPoint(x: 136 - offsetX, y: 324 - offsetY))
    path.addLine(to: CGPoint(x: 218 - offsetX, y: 273 - offsetY))
    path.addLine(to: CGPoint(x: 217 - offsetX, y: 242 - offsetY))
    path.addLine(to: CGPoint(x: 240 - offsetX, y: 214 - offsetY))
    path.addLine(to: CGPoint(x: 261 - offsetX, y: 185 - offsetY))
    path.addLine(to: CGPoint(x: 203 - offsetX, y: 111 - offsetY))
    path.addLine(to: CGPoint(x: 141 - offsetX, y: 129 - offsetY))
    path.addLine(to: CGPoint(x: 109 - offsetX, y: 119 - offsetY))
    path.addLine(to: CGPoint(x: 105 - offsetX, y: 91 - offsetY))
    path.addLine(to: CGPoint(x: 152 - offsetX, y: 94 - offsetY))
    path.addLine(to: CGPoint(x: 165 - offsetX, y: 74 - offsetY))
    path.addLine(to: CGPoint(x: 134 - offsetX, y: 38 - offsetY))
    path.addLine(to: CGPoint(x: 101 - offsetX, y: 24 - offsetY))
    path.addLine(to: CGPoint(x: 38 - offsetX, y: 57 - offsetY))
    path.addLine(to: CGPoint(x: 34 - offsetX, y: 78 - offsetY))
    path.addLine(to: CGPoint(x: 14 - offsetX, y: 95 - offsetY))
    path.addLine(to: CGPoint(x: 40 - offsetX, y: 111 - offsetY))
    path.addLine(to: CGPoint(x: 40 - offsetX, y: 137 - offsetY))
    path.addLine(to: CGPoint(x: 22 - offsetX, y: 170 - offsetY))
    path.addLine(to: CGPoint(x: 53 - offsetX, y: 176 - offsetY))
    path.addLine(to: CGPoint(x: 42 - offsetX, y: 199 - offsetY))
    path.addLine(to: CGPoint(x: 35 - offsetX, y: 209 - offsetY))
    path.addLine(to: CGPoint(x: 57 - offsetX, y: 227 - offsetY))
    path.addLine(to: CGPoint(x: 52 - offsetX, y: 242 - offsetY))
    path.addLine(to: CGPoint(x: 71 - offsetX, y: 250 - offsetY))
    path.addLine(to: CGPoint(x: 104 - offsetX, y: 269 - offsetY))
    path.addLine(to: CGPoint(x: 90 - offsetX, y: 314 - offsetY))
    path.addLine(to: CGPoint(x: 87 - offsetX, y: 344 - offsetY))
    
    path.closeSubpath()
    return path
}

func bodyPolygonForTexture_stone01(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 48 - offsetX, y: 178 - offsetY))
    path.addLine(to: CGPoint(x: 64 - offsetX, y: 177 - offsetY))
    path.addLine(to: CGPoint(x: 108 - offsetX, y: 165 - offsetY))
    path.addLine(to: CGPoint(x: 151 - offsetX, y: 165 - offsetY))
    path.addLine(to: CGPoint(x: 167 - offsetX, y: 161 - offsetY))
    path.addLine(to: CGPoint(x: 187 - offsetX, y: 127 - offsetY))
    path.addLine(to: CGPoint(x: 196 - offsetX, y: 99 - offsetY))
    path.addLine(to: CGPoint(x: 193 - offsetX, y: 80 - offsetY))
    path.addLine(to: CGPoint(x: 173 - offsetX, y: 38 - offsetY))
    path.addLine(to: CGPoint(x: 163 - offsetX, y: 26 - offsetY))
    path.addLine(to: CGPoint(x: 142 - offsetX, y: 15 - offsetY))
    path.addLine(to: CGPoint(x: 112 - offsetX, y: 13 - offsetY))
    path.addLine(to: CGPoint(x: 82 - offsetX, y: 9 - offsetY))
    path.addLine(to: CGPoint(x: 59 - offsetX, y: 9 - offsetY))
    path.addLine(to: CGPoint(x: 39 - offsetX, y: 23 - offsetY))
    path.addLine(to: CGPoint(x: 17 - offsetX, y: 48 - offsetY))
    path.addLine(to: CGPoint(x: 1 - offsetX, y: 81 - offsetY))
    path.addLine(to: CGPoint(x: 0 - offsetX, y: 106 - offsetY))
    path.addLine(to: CGPoint(x: 14 - offsetX, y: 139 - offsetY))
    path.addLine(to: CGPoint(x: 25 - offsetX, y: 160 - offsetY))
    path.addLine(to: CGPoint(x: 37 - offsetX, y: 173 - offsetY))
    
    path.closeSubpath()
    return path
}

func bodyPolygonForTexture_stone02(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 76 - offsetX, y: 175 - offsetY))
    path.addLine(to: CGPoint(x: 97 - offsetX, y: 166 - offsetY))
    path.addLine(to: CGPoint(x: 106 - offsetX, y: 154 - offsetY))
    path.addLine(to: CGPoint(x: 117 - offsetX, y: 128 - offsetY))
    path.addLine(to: CGPoint(x: 135 - offsetX, y: 95 - offsetY))
    path.addLine(to: CGPoint(x: 140 - offsetX, y: 70 - offsetY))
    path.addLine(to: CGPoint(x: 145 - offsetX, y: 46 - offsetY))
    path.addLine(to: CGPoint(x: 128 - offsetX, y: 14 - offsetY))
    path.addLine(to: CGPoint(x: 118 - offsetX, y: 9 - offsetY))
    path.addLine(to: CGPoint(x: 103 - offsetX, y: 10 - offsetY))
    path.addLine(to: CGPoint(x: 90 - offsetX, y: 14 - offsetY))
    path.addLine(to: CGPoint(x: 49 - offsetX, y: 38 - offsetY))
    path.addLine(to: CGPoint(x: 36 - offsetX, y: 49 - offsetY))
    path.addLine(to: CGPoint(x: 16 - offsetX, y: 73 - offsetY))
    path.addLine(to: CGPoint(x: 5 - offsetX, y: 100 - offsetY))
    path.addLine(to: CGPoint(x: 1 - offsetX, y: 125 - offsetY))
    path.addLine(to: CGPoint(x: 5 - offsetX, y: 144 - offsetY))
    path.addLine(to: CGPoint(x: 19 - offsetX, y: 161 - offsetY))
    path.addLine(to: CGPoint(x: 34 - offsetX, y: 170 - offsetY))
    
    path.closeSubpath()
    return path
}

func bodyPolygonForTexture_stone03(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 119 - offsetX, y: 104 - offsetY))
    path.addLine(to: CGPoint(x: 137 - offsetX, y: 99 - offsetY))
    path.addLine(to: CGPoint(x: 161 - offsetX, y: 76 - offsetY))
    path.addLine(to: CGPoint(x: 161 - offsetX, y: 56 - offsetY))
    path.addLine(to: CGPoint(x: 139 - offsetX, y: 42 - offsetY))
    path.addLine(to: CGPoint(x: 112 - offsetX, y: 29 - offsetY))
    path.addLine(to: CGPoint(x: 78 - offsetX, y: 17 - offsetY))
    path.addLine(to: CGPoint(x: 49 - offsetX, y: 10 - offsetY))
    path.addLine(to: CGPoint(x: 28 - offsetX, y: 9 - offsetY))
    path.addLine(to: CGPoint(x: 9 - offsetX, y: 13 - offsetY))
    path.addLine(to: CGPoint(x: 4 - offsetX, y: 22 - offsetY))
    path.addLine(to: CGPoint(x: 2 - offsetX, y: 37 - offsetY))
    path.addLine(to: CGPoint(x: 2 - offsetX, y: 52 - offsetY))
    path.addLine(to: CGPoint(x: 3 - offsetX, y: 66 - offsetY))
    path.addLine(to: CGPoint(x: 14 - offsetX, y: 80 - offsetY))
    path.addLine(to: CGPoint(x: 32 - offsetX, y: 92 - offsetY))
    path.addLine(to: CGPoint(x: 58 - offsetX, y: 104 - offsetY))
    path.addLine(to: CGPoint(x: 79 - offsetX, y: 109 - offsetY))
    path.addLine(to: CGPoint(x: 98 - offsetX, y: 111 - offsetY))
    
    path.closeSubpath()
    return path
}

func bodyPolygonForTexture_stone04(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 74 - offsetX, y: 145 - offsetY))
    path.addLine(to: CGPoint(x: 121 - offsetX, y: 119 - offsetY))
    path.addLine(to: CGPoint(x: 131 - offsetX, y: 109 - offsetY))
    path.addLine(to: CGPoint(x: 135 - offsetX, y: 81 - offsetY))
    path.addLine(to: CGPoint(x: 133 - offsetX, y: 50 - offsetY))
    path.addLine(to: CGPoint(x: 126 - offsetX, y: 38 - offsetY))
    path.addLine(to: CGPoint(x: 109 - offsetX, y: 26 - offsetY))
    path.addLine(to: CGPoint(x: 87 - offsetX, y: 15 - offsetY))
    path.addLine(to: CGPoint(x: 70 - offsetX, y: 11 - offsetY))
    path.addLine(to: CGPoint(x: 58 - offsetX, y: 8 - offsetY))
    path.addLine(to: CGPoint(x: 43 - offsetX, y: 11 - offsetY))
    path.addLine(to: CGPoint(x: 24 - offsetX, y: 13 - offsetY))
    path.addLine(to: CGPoint(x: 17 - offsetX, y: 16 - offsetY))
    path.addLine(to: CGPoint(x: 11 - offsetX, y: 23 - offsetY))
    path.addLine(to: CGPoint(x: 7 - offsetX, y: 37 - offsetY))
    path.addLine(to: CGPoint(x: 7 - offsetX, y: 88 - offsetY))
    path.addLine(to: CGPoint(x: 2 - offsetX, y: 104 - offsetY))
    path.addLine(to: CGPoint(x: 2 - offsetX, y: 119 - offsetY))
    path.addLine(to: CGPoint(x: 6 - offsetX, y: 129 - offsetY))
    path.addLine(to: CGPoint(x: 20 - offsetX, y: 139 - offsetY))
    path.addLine(to: CGPoint(x: 55 - offsetX, y: 150 - offsetY))
    
    path.closeSubpath()
    return path
}

func bodyPolygonForTexture_stone05(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 72 - offsetX, y: 146 - offsetY))
    path.addLine(to: CGPoint(x: 95 - offsetX, y: 136 - offsetY))
    path.addLine(to: CGPoint(x: 103 - offsetX, y: 130 - offsetY))
    path.addLine(to: CGPoint(x: 122 - offsetX, y: 83 - offsetY))
    path.addLine(to: CGPoint(x: 124 - offsetX, y: 69 - offsetY))
    path.addLine(to: CGPoint(x: 115 - offsetX, y: 57 - offsetY))
    path.addLine(to: CGPoint(x: 105 - offsetX, y: 48 - offsetY))
    path.addLine(to: CGPoint(x: 91 - offsetX, y: 26 - offsetY))
    path.addLine(to: CGPoint(x: 77 - offsetX, y: 12 - offsetY))
    path.addLine(to: CGPoint(x: 67 - offsetX, y: 7 - offsetY))
    path.addLine(to: CGPoint(x: 46 - offsetX, y: 17 - offsetY))
    path.addLine(to: CGPoint(x: 25 - offsetX, y: 37 - offsetY))
    path.addLine(to: CGPoint(x: 11 - offsetX, y: 60 - offsetY))
    path.addLine(to: CGPoint(x: 3 - offsetX, y: 83 - offsetY))
    path.addLine(to: CGPoint(x: 0 - offsetX, y: 102 - offsetY))
    path.addLine(to: CGPoint(x: 3 - offsetX, y: 110 - offsetY))
    path.addLine(to: CGPoint(x: 23 - offsetX, y: 129 - offsetY))
    path.addLine(to: CGPoint(x: 30 - offsetX, y: 137 - offsetY))
    path.addLine(to: CGPoint(x: 45 - offsetX, y: 147 - offsetY))
    
    path.closeSubpath()
    return path
}

func bodyPolygonForTexture_stone06(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 34 - offsetX, y: 97 - offsetY))
    path.addLine(to: CGPoint(x: 58 - offsetX, y: 97 - offsetY))
    path.addLine(to: CGPoint(x: 76 - offsetX, y: 91 - offsetY))
    path.addLine(to: CGPoint(x: 96 - offsetX, y: 75 - offsetY))
    path.addLine(to: CGPoint(x: 120 - offsetX, y: 55 - offsetY))
    path.addLine(to: CGPoint(x: 124 - offsetX, y: 46 - offsetY))
    path.addLine(to: CGPoint(x: 119 - offsetX, y: 32 - offsetY))
    path.addLine(to: CGPoint(x: 117 - offsetX, y: 22 - offsetY))
    path.addLine(to: CGPoint(x: 104 - offsetX, y: 12 - offsetY))
    path.addLine(to: CGPoint(x: 76 - offsetX, y: 13 - offsetY))
    path.addLine(to: CGPoint(x: 60 - offsetX, y: 11 - offsetY))
    path.addLine(to: CGPoint(x: 42 - offsetX, y: 8 - offsetY))
    path.addLine(to: CGPoint(x: 23 - offsetX, y: 15 - offsetY))
    path.addLine(to: CGPoint(x: 4 - offsetX, y: 32 - offsetY))
    path.addLine(to: CGPoint(x: 1 - offsetX, y: 49 - offsetY))
    path.addLine(to: CGPoint(x: 3 - offsetX, y: 65 - offsetY))
    path.addLine(to: CGPoint(x: 12 - offsetX, y: 79 - offsetY))
    path.addLine(to: CGPoint(x: 25 - offsetX, y: 94 - offsetY))
    
    path.closeSubpath()
    return path
}

func bodyPolygonForTexture_stone07(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 83 - offsetX, y: 120 - offsetY))
    path.addLine(to: CGPoint(x: 89 - offsetX, y: 113 - offsetY))
    path.addLine(to: CGPoint(x: 100 - offsetX, y: 74 - offsetY))
    path.addLine(to: CGPoint(x: 99 - offsetX, y: 58 - offsetY))
    path.addLine(to: CGPoint(x: 85 - offsetX, y: 34 - offsetY))
    path.addLine(to: CGPoint(x: 68 - offsetX, y: 15 - offsetY))
    path.addLine(to: CGPoint(x: 58 - offsetX, y: 8 - offsetY))
    path.addLine(to: CGPoint(x: 43 - offsetX, y: 8 - offsetY))
    path.addLine(to: CGPoint(x: 28 - offsetX, y: 12 - offsetY))
    path.addLine(to: CGPoint(x: 12 - offsetX, y: 13 - offsetY))
    path.addLine(to: CGPoint(x: 3 - offsetX, y: 28 - offsetY))
    path.addLine(to: CGPoint(x: 1 - offsetX, y: 47 - offsetY))
    path.addLine(to: CGPoint(x: 1 - offsetX, y: 64 - offsetY))
    path.addLine(to: CGPoint(x: 6 - offsetX, y: 85 - offsetY))
    path.addLine(to: CGPoint(x: 15 - offsetX, y: 102 - offsetY))
    path.addLine(to: CGPoint(x: 25 - offsetX, y: 111 - offsetY))
    path.addLine(to: CGPoint(x: 36 - offsetX, y: 117 - offsetY))
    path.addLine(to: CGPoint(x: 49 - offsetX, y: 123 - offsetY))
    path.addLine(to: CGPoint(x: 59 - offsetX, y: 125 - offsetY))
    path.addLine(to: CGPoint(x: 70 - offsetX, y: 122 - offsetY))
    
    path.closeSubpath()
    return path
}

func bodyPolygonForTexture_stone08(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 64 - offsetX, y: 117 - offsetY))
    path.addLine(to: CGPoint(x: 78 - offsetX, y: 113 - offsetY))
    path.addLine(to: CGPoint(x: 88 - offsetX, y: 109 - offsetY))
    path.addLine(to: CGPoint(x: 112 - offsetX, y: 86 - offsetY))
    path.addLine(to: CGPoint(x: 119 - offsetX, y: 73 - offsetY))
    path.addLine(to: CGPoint(x: 114 - offsetX, y: 59 - offsetY))
    path.addLine(to: CGPoint(x: 102 - offsetX, y: 48 - offsetY))
    path.addLine(to: CGPoint(x: 88 - offsetX, y: 38 - offsetY))
    path.addLine(to: CGPoint(x: 75 - offsetX, y: 22 - offsetY))
    path.addLine(to: CGPoint(x: 65 - offsetX, y: 11 - offsetY))
    path.addLine(to: CGPoint(x: 56 - offsetX, y: 8 - offsetY))
    path.addLine(to: CGPoint(x: 35 - offsetX, y: 14 - offsetY))
    path.addLine(to: CGPoint(x: 17 - offsetX, y: 22 - offsetY))
    path.addLine(to: CGPoint(x: 6 - offsetX, y: 30 - offsetY))
    path.addLine(to: CGPoint(x: 1 - offsetX, y: 49 - offsetY))
    path.addLine(to: CGPoint(x: 1 - offsetX, y: 70 - offsetY))
    path.addLine(to: CGPoint(x: 3 - offsetX, y: 88 - offsetY))
    path.addLine(to: CGPoint(x: 6 - offsetX, y: 97 - offsetY))
    path.addLine(to: CGPoint(x: 14 - offsetX, y: 105 - offsetY))
    path.addLine(to: CGPoint(x: 23 - offsetX, y: 111 - offsetY))
    path.addLine(to: CGPoint(x: 45 - offsetX, y: 119 - offsetY))
    
    path.closeSubpath()
    return path
}

func bodyPolygonForTexture_stone09(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 84 - offsetX, y: 111 - offsetY))
    path.addLine(to: CGPoint(x: 96 - offsetX, y: 102 - offsetY))
    path.addLine(to: CGPoint(x: 118 - offsetX, y: 84 - offsetY))
    path.addLine(to: CGPoint(x: 133 - offsetX, y: 68 - offsetY))
    path.addLine(to: CGPoint(x: 142 - offsetX, y: 55 - offsetY))
    path.addLine(to: CGPoint(x: 143 - offsetX, y: 41 - offsetY))
    path.addLine(to: CGPoint(x: 137 - offsetX, y: 26 - offsetY))
    path.addLine(to: CGPoint(x: 123 - offsetX, y: 16 - offsetY))
    path.addLine(to: CGPoint(x: 110 - offsetX, y: 9 - offsetY))
    path.addLine(to: CGPoint(x: 91 - offsetX, y: 9 - offsetY))
    path.addLine(to: CGPoint(x: 69 - offsetX, y: 15 - offsetY))
    path.addLine(to: CGPoint(x: 47 - offsetX, y: 25 - offsetY))
    path.addLine(to: CGPoint(x: 31 - offsetX, y: 34 - offsetY))
    path.addLine(to: CGPoint(x: 16 - offsetX, y: 44 - offsetY))
    path.addLine(to: CGPoint(x: 3 - offsetX, y: 58 - offsetY))
    path.addLine(to: CGPoint(x: 1 - offsetX, y: 72 - offsetY))
    path.addLine(to: CGPoint(x: 2 - offsetX, y: 89 - offsetY))
    path.addLine(to: CGPoint(x: 5 - offsetX, y: 101 - offsetY))
    path.addLine(to: CGPoint(x: 7 - offsetX, y: 114 - offsetY))
    path.addLine(to: CGPoint(x: 14 - offsetX, y: 123 - offsetY))
    path.addLine(to: CGPoint(x: 26 - offsetX, y: 126 - offsetY))
    path.addLine(to: CGPoint(x: 52 - offsetX, y: 121 - offsetY))
    
    path.closeSubpath()
    return path
}

func bodyPolygonForTexture_stone10(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 83 - offsetX, y: 140 - offsetY))
    path.addLine(to: CGPoint(x: 107 - offsetX, y: 128 - offsetY))
    path.addLine(to: CGPoint(x: 122 - offsetX, y: 116 - offsetY))
    path.addLine(to: CGPoint(x: 131 - offsetX, y: 104 - offsetY))
    path.addLine(to: CGPoint(x: 134 - offsetX, y: 87 - offsetY))
    path.addLine(to: CGPoint(x: 133 - offsetX, y: 60 - offsetY))
    path.addLine(to: CGPoint(x: 128 - offsetX, y: 45 - offsetY))
    path.addLine(to: CGPoint(x: 115 - offsetX, y: 33 - offsetY))
    path.addLine(to: CGPoint(x: 100 - offsetX, y: 22 - offsetY))
    path.addLine(to: CGPoint(x: 82 - offsetX, y: 13 - offsetY))
    path.addLine(to: CGPoint(x: 64 - offsetX, y: 9 - offsetY))
    path.addLine(to: CGPoint(x: 43 - offsetX, y: 8 - offsetY))
    path.addLine(to: CGPoint(x: 26 - offsetX, y: 12 - offsetY))
    path.addLine(to: CGPoint(x: 17 - offsetX, y: 26 - offsetY))
    path.addLine(to: CGPoint(x: 14 - offsetX, y: 46 - offsetY))
    path.addLine(to: CGPoint(x: 14 - offsetX, y: 62 - offsetY))
    path.addLine(to: CGPoint(x: 11 - offsetX, y: 77 - offsetY))
    path.addLine(to: CGPoint(x: 4 - offsetX, y: 93 - offsetY))
    path.addLine(to: CGPoint(x: 1 - offsetX, y: 106 - offsetY))
    path.addLine(to: CGPoint(x: 5 - offsetX, y: 118 - offsetY))
    path.addLine(to: CGPoint(x: 19 - offsetX, y: 130 - offsetY))
    path.addLine(to: CGPoint(x: 35 - offsetX, y: 139 - offsetY))
    path.addLine(to: CGPoint(x: 53 - offsetX, y: 146 - offsetY))
    path.addLine(to: CGPoint(x: 65 - offsetX, y: 146 - offsetY))
    
    path.closeSubpath()
    return path
}

func bodyPolygonForTexture_stone11(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 85 - offsetX, y: 132 - offsetY))
    path.addLine(to: CGPoint(x: 101 - offsetX, y: 127 - offsetY))
    path.addLine(to: CGPoint(x: 115 - offsetX, y: 119 - offsetY))
    path.addLine(to: CGPoint(x: 127 - offsetX, y: 110 - offsetY))
    path.addLine(to: CGPoint(x: 140 - offsetX, y: 94 - offsetY))
    path.addLine(to: CGPoint(x: 147 - offsetX, y: 82 - offsetY))
    path.addLine(to: CGPoint(x: 143 - offsetX, y: 69 - offsetY))
    path.addLine(to: CGPoint(x: 133 - offsetX, y: 59 - offsetY))
    path.addLine(to: CGPoint(x: 117 - offsetX, y: 47 - offsetY))
    path.addLine(to: CGPoint(x: 102 - offsetX, y: 34 - offsetY))
    path.addLine(to: CGPoint(x: 90 - offsetX, y: 21 - offsetY))
    path.addLine(to: CGPoint(x: 76 - offsetX, y: 8 - offsetY))
    path.addLine(to: CGPoint(x: 58 - offsetX, y: 10 - offsetY))
    path.addLine(to: CGPoint(x: 39 - offsetX, y: 17 - offsetY))
    path.addLine(to: CGPoint(x: 20 - offsetX, y: 26 - offsetY))
    path.addLine(to: CGPoint(x: 5 - offsetX, y: 36 - offsetY))
    path.addLine(to: CGPoint(x: 1 - offsetX, y: 53 - offsetY))
    path.addLine(to: CGPoint(x: 1 - offsetX, y: 74 - offsetY))
    path.addLine(to: CGPoint(x: 4 - offsetX, y: 94 - offsetY))
    path.addLine(to: CGPoint(x: 11 - offsetX, y: 115 - offsetY))
    path.addLine(to: CGPoint(x: 21 - offsetX, y: 124 - offsetY))
    path.addLine(to: CGPoint(x: 42 - offsetX, y: 133 - offsetY))
    path.addLine(to: CGPoint(x: 58 - offsetX, y: 136 - offsetY))
    
    path.closeSubpath()
    return path
}

func bodyPolygonForTexture_stone12(_ sprite:SKSpriteNode) -> CGPath? {
    let offsetX = CGFloat(sprite.size.width * sprite.anchorPoint.x)
    let offsetY = CGFloat(sprite.size.height * sprite.anchorPoint.y)
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: 95 - offsetX, y: 177 - offsetY))
    path.addLine(to: CGPoint(x: 108 - offsetX, y: 165 - offsetY))
    path.addLine(to: CGPoint(x: 118 - offsetX, y: 152 - offsetY))
    path.addLine(to: CGPoint(x: 134 - offsetX, y: 127 - offsetY))
    path.addLine(to: CGPoint(x: 144 - offsetX, y: 116 - offsetY))
    path.addLine(to: CGPoint(x: 145 - offsetX, y: 104 - offsetY))
    path.addLine(to: CGPoint(x: 136 - offsetX, y: 81 - offsetY))
    path.addLine(to: CGPoint(x: 122 - offsetX, y: 61 - offsetY))
    path.addLine(to: CGPoint(x: 111 - offsetX, y: 42 - offsetY))
    path.addLine(to: CGPoint(x: 95 - offsetX, y: 20 - offsetY))
    path.addLine(to: CGPoint(x: 78 - offsetX, y: 9 - offsetY))
    path.addLine(to: CGPoint(x: 53 - offsetX, y: 12 - offsetY))
    path.addLine(to: CGPoint(x: 28 - offsetX, y: 24 - offsetY))
    path.addLine(to: CGPoint(x: 12 - offsetX, y: 39 - offsetY))
    path.addLine(to: CGPoint(x: 6 - offsetX, y: 64 - offsetY))
    path.addLine(to: CGPoint(x: 1 - offsetX, y: 84 - offsetY))
    path.addLine(to: CGPoint(x: 3 - offsetX, y: 105 - offsetY))
    path.addLine(to: CGPoint(x: 11 - offsetX, y: 136 - offsetY))
    path.addLine(to: CGPoint(x: 22 - offsetX, y: 159 - offsetY))
    path.addLine(to: CGPoint(x: 36 - offsetX, y: 173 - offsetY))
    path.addLine(to: CGPoint(x: 57 - offsetX, y: 183 - offsetY))
    path.addLine(to: CGPoint(x: 75 - offsetX, y: 185 - offsetY))
    
    path.closeSubpath()
    return path
}
