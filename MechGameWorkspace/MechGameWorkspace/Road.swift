//
//  Road.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 2/11/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class Road : Object {
    
    var spazTime = 0
    var destroyedSprite: SKSpriteNode?
    
    init(x: CGFloat, y: CGFloat, vertical: Bool? = nil) {
        super.init(x: x, y: y, file: vertical == nil ? "road_m.png" : vertical! ? "road_v.png" : "road_h.png")
        sprite.color = UIColor.redColor()
        sprite.colorBlendFactor = 0.0
        health = 50
        sprite.zPosition = -5000
    }
    
    override func update(currentTime: CFTimeInterval) {
        super.update(currentTime)
        if spazTime-- > 0 {
            if spazTime % 2 == 1 {
                sprite.colorBlendFactor = 1.0
            }
            else {
                sprite.colorBlendFactor = 0.0
            }
        }
    }
    
    override func destroy() {
        gameScene.addObject(DestroyedTile(obj: self))
    }
}