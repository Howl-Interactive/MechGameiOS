
//
//  Bullet.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 4/26/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class Bullet : Object {
    
    let SPEED: CGFloat = 15
    
    init(x: CGFloat, y: CGFloat, target: Object) {
        super.init(x: x, y: y, w: 6, h: 6, file: "missile01.png", type: .FRIENDLY)
        vel = normalize(target.pos - pos) * SPEED
        damage = 20
        sprite.runAction(SKAction.rotateToAngle(atan2(target.pos.y - pos.y, target.pos.x - pos.x) - CGFloat(M_PI) / 2, duration: 0))
    }
    
    override func update(currentTime: CFTimeInterval) {
        sprite.zPosition = -y
        super.update(currentTime)
    }
    
    override func collision(obj: Object) {
        switch obj.type {
        case .SOLID:
            takeDamage(obj)
            obj.takeDamage(self)
            gameScene.addObject(Explosion(x: obj.x, y: obj.y))
            break
        case .ENEMY:
            takeDamage(obj)
            obj.takeDamage(self)
            gameScene.addObject(Explosion(x: x, y: y))
            break
        default:
            break
        }
    }
    
    override func takeDamage(obj: Object) {
        isAlive = false
        audioController.play("hit03-2.wav")
    }
}