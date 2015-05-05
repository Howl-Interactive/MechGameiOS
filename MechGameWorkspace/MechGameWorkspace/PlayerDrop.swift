//
//  PlayerDrop.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 5/4/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class PlayerDrop : Object {
    
    var counter = 1
    var explosionSprite = SKSpriteNode(imageNamed: "air_strike_laser14.png")
    var splash: CGFloat = 50
    
    init(x: CGFloat, y: CGFloat) {
        super.init(x: x, y: y, keepImageSize: true, file: "enemy_drop1.png", type: .NONE)
        sprite.anchorPoint = CGPoint(x: 0.5, y: 0)
        sprite.size = CGSize(width: 20, height: 450)
        sprite.zPosition = 2
        explosionSprite.zPosition = 3
        damage = 150
    }
    
    override func update(currentTime: CFTimeInterval) {
        if ++counter <= 29 {
            if counter == 10 {
                audioController.play("landing01.wav")
            }
            sprite.texture = SKTexture(imageNamed: "enemy_drop\(counter)")
        }
        else if counter == 30 {
            sprite.texture = SKTexture(imageNamed: "enemy_drop\(counter)")
            sprite.addChild(explosionSprite)
            for obj in gameScene.objs {
                if (obj is Building || obj is Enemy || obj is Player || obj is Road) && distance(pos, obj.pos) < splash {
                    obj.takeDamage(self)
                    if obj is Road || obj is Building {
                        obj.sprite.hidden = true
                    }
                }
            }
        }
        else if counter <= 33 {
            sprite.texture = SKTexture(imageNamed: "enemy_drop\(counter)")
            explosionSprite.texture = SKTexture(imageNamed: "air_strike_laser\(counter - 16)")
        }
        else if counter == 34 {
            sprite.texture = SKTexture(imageNamed: "air_strike_blank")
            explosionSprite.texture = SKTexture(imageNamed: "air_strike_laser\(counter - 16)")
        }
        else if counter <= 47 {
            if counter == 40 {
                gameScene.p.sprite.zPosition = 1
                gameScene.addObject(gameScene.p)
            }
            explosionSprite.texture = SKTexture(imageNamed: "air_strike_laser\(counter - 16)")
        }
        else {
            gameScene.started = true
            sprite.removeFromParent()
            gameScene.playerDrop = nil
        }
    }
}