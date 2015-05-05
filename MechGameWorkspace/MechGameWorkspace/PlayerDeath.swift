//
//  PlayerDeath.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 5/4/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class PlayerDeath : SKSpriteNode {
    
    var counter = 1
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(x: CGFloat, y: CGFloat) {
        let t = SKTexture(imageNamed: "player_die_1")
        super.init(texture: t, color: nil, size: t.size())
        position = CGPoint(x: x, y: y)
        gameScene.p.sprite.hidden = true
        color = COLORS[Int(arc4random_uniform(UInt32(COLORS.count)))]
        colorBlendFactor = 1.0
        runAction(SKAction.repeatAction(SKAction.customActionWithDuration(0.1, actionBlock: {(SKNode, CGFloat) in
            if ++self.counter <= 16 {
                self.texture = SKTexture(imageNamed: "player_die_\(self.counter).png")
                self.color = COLORS[Int(arc4random_uniform(UInt32(COLORS.count)))]
            }
            else if self.counter == 17 {
                ui.addChild(ui.endScreen)
                ui.endScreen.turnOn()
                self.removeFromParent()
            }
        }), count: 18))
    }
}