//
//  EnemyDrop.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 5/3/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class EnemyDrop : Object {
    
    var counter = 1
    var splash: CGFloat = 50
    
    init(x: CGFloat, y: CGFloat) {
        super.init(x: x, y: y, keepImageSize: true, file: "enemy_drop1.png", type: .NONE)
        sprite.anchorPoint = CGPoint(x: 0.5, y: 0)
        sprite.size = CGSize(width: 20, height: 450)
        damage = 150
    }
    
    override func update(currentTime: CFTimeInterval) {
        if ++counter <= 33 {
            sprite.texture = SKTexture(imageNamed: "enemy_drop\(++counter)")
        }
        else if counter <= 51 {
            sprite.texture = SKTexture(imageNamed: "air_strike_laser\(counter - 20)")
            if counter == 34 {
                audioController.play("landing01.wav")
                for obj in gameScene.objs {
                    if (obj is Building || obj is Enemy || obj is Player || obj is Road) && distance(pos, obj.pos) < splash {
                        obj.takeDamage(self)
                    }
                }
                gameScene.addObject(Enemy(x: x, y: y))
                sprite.size = CGSize(width: 60, height: 120)
                sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            }
        }
        else {
            isAlive = false
        }
    }
}