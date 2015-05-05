//
//  Airstrike.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 4/30/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class Airstrike : Object {
    
    let splash: CGFloat = 100
    var counter = 0, redLaserTime = 50, delay: Int
    var explosion = SKSpriteNode(imageNamed: "air_strike_laser14.png")
    
    init(x: CGFloat, y: CGFloat, delay: Int) {
        self.delay = delay
        super.init(x: x, y: y, file: "as_red.png", type: .NONE)
        sprite.anchorPoint = CGPoint(x: 0.5, y: 0)
        sprite.hidden = true
        explosion.anchorPoint = CGPoint(x: 0.5, y: 0.4)
        damage = 150
    }
    
    override func update(currentTime: CFTimeInterval) {
        if counter++ > delay {
            sprite.hidden = false
            if counter > redLaserTime + delay {
                var c = counter - redLaserTime - delay
                if c <= 8 {
                    if c <= 6 {
                        audioController.play("shot01-2.wav")
                    }
                    sprite.texture = SKTexture(imageNamed: "air_strike_laser\(c).png")
                }
                else if c == 9 {
                    sprite.texture = SKTexture(imageNamed: "air_strike_laser\(c).png")
                    sprite.addChild(explosion)
                    for obj in gameScene.objs {
                        if (obj is Building || obj is Enemy || obj is Player || obj is Road) && distance(pos, obj.pos) < splash {
                            obj.takeDamage(self)
                        }
                    }
                }
                else if c <= 13 {
                    sprite.texture = SKTexture(imageNamed: "air_strike_laser\(c).png")
                    explosion.texture = SKTexture(imageNamed: "air_strike_laser\(c + 5).png")
                }
                else if c == 14 {
                    sprite.texture = SKTexture(imageNamed: "air_strike_blank.png")
                    explosion.texture = SKTexture(imageNamed: "air_strike_laser\(c + 5).png")
                }
                else if c <= 26 {
                    explosion.texture = SKTexture(imageNamed: "air_strike_laser\(c + 5).png")
                }
                else {
                    isAlive = false
                }
            }
        }
    }
}