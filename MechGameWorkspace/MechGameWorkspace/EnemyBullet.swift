//
//  EnemyBullet.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 4/30/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class EnemyBullet : Object {
    
    let SPEED: CGFloat = 1.5, ACC: CGFloat = 0.2
    
    init(x: CGFloat, y: CGFloat) {
        super.init(x: x, y: y, w: 10, h: 10, file: "missile01.png", type: .ENEMY)
        self.vel = normalize(gameScene.p.pos - pos) * SPEED
        damage = 35
    }
    
    override func update(currentTime: CFTimeInterval) {
        sprite.zPosition = -y
        vel += normalize(gameScene.p.pos - pos) * ACC
        sprite.runAction(SKAction.rotateToAngle(atan2(gameScene.p.y - y, gameScene.p.x - x) - CGFloat(M_PI) / 2, duration: 0))
        super.update(currentTime)
    }
    
    override func collision(obj: Object) {
        switch obj.type {
        case .SOLID:
            takeDamage(obj)
            obj.takeDamage(self)
            gameScene.addObject(Explosion(x: obj.x, y: obj.y))
            break
        case .PLAYER:
            if gameScene.p.invulnerable == 0 {
                gameScene.p.spaz()
            }
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
    }
}