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
        runAction(SKAction.repeatAction(SKAction.customActionWithDuration(0.1, actionBlock: {(SKNode, CGFloat) in
            if ++self.counter <= 29 {
                self.texture = SKTexture(imageNamed: "title_\(self.counter).png")
            }
            else if self.counter == 30 {
                ui.endScreen.blackScreen.runAction(SKAction.fadeOutWithDuration(1), completion: { ui.endScreen.blackScreen.zPosition = -1 })
            }
        }), count: 18))
    }
}