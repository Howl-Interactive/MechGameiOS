//
//  Missile.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 4/26/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class Missile : Object {
    
    let SPEED: CGFloat = 1, ACC: CGFloat = 0.4
    weak var target: Object?
    
    init(x: CGFloat, y: CGFloat, target: Object, vel: CGPoint? = nil) {
        super.init(x: x, y: y, w: 10, h: 10, file: "missile01.png", type: .FRIENDLY)
        if let v = vel {
            self.vel = v
        }
        else {
            self.vel = normalize(target.pos - pos) * SPEED
        }
        self.target = target
        damage = 35
    }
    
    override func update(currentTime: CFTimeInterval) {
        sprite.zPosition = -y
        if let t = target {
            vel += normalize(t.pos - pos) * ACC
            sprite.runAction(SKAction.rotateToAngle(atan2(t.pos.y - pos.y, t.pos.x - pos.x) - CGFloat(M_PI) / 2, duration: 0))
        }
        else {
            vel += normalize(vel) * ACC
            sprite.runAction(SKAction.rotateToAngle(atan2(vel.y, vel.x) - CGFloat(M_PI) / 2, duration: 0))
        }
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