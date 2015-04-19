
//
//  Enemy.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 2/19/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class Enemy : Object {
    
    var speed: CGFloat = 3
    
    init(x: CGFloat, y: CGFloat) {
        super.init(x: x, y: y, w: 20, h: 20, file: "enemy00.png", type: Type.ENEMY)
    }
    
    override func update(currentTime: CFTimeInterval) {
        sprite.zPosition = -y
        var diff = CGPoint(x: x - scene.p.x, y: y - scene.p.y)
        vel = CGPoint(x: speed * (abs(diff.x) < 5 ? 0 : diff.x < 0 ? 1 : -1), y: speed * (abs(diff.y) < 5 ? 0 : diff.y < 0 ? 1 : -1))
        super.update(currentTime)
        if y < -200 || y > HEIGHT + 200 {
            isAlive = false
        }
    }
    
    override func collision(obj: Object) {
        switch obj.type {
        case .SOLID:
            solidCollision(obj)
            break
        case .PLAYER:
            obj.takeDamage(self)
            scene.p.spaz()
            break
        case .FRIENDLY:
            takeDamage(obj)
            break
        default:
            break
        }
    }
}