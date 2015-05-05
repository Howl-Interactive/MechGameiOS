//
//  Shield.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 4/30/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class Shield : Object {
    
    var spazTime = 0
    var image = SKShapeNode(circleOfRadius: 20)
    
    init() {
        super.init(x: gameScene.p.x, y: gameScene.p.y, file: "blank.png", type: .NONE)
        invulnerableTime = gameScene.p.invulnerableTime
        sprite.addChild(image)
        image.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.scaleTo(1.3, duration: 0.8),
            SKAction.scaleTo(1, duration: 0.8)
        ])))
    }
    
    override func update(currentTime: CFTimeInterval) {
        if invulnerable != 0 { invulnerable-- }
        x = gameScene.p.x
        y = gameScene.p.y
        if spazTime-- > 0 {
            if spazTime % 2 == 1 {
                sprite.runAction(SKAction.hide())
            }
            else {
                sprite.runAction(SKAction.unhide())
            }
        }
    }
    
    override func destroy() {
        gameScene.p.shield = nil
    }
}