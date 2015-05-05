
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
    var target: Object?
    
    init(x: CGFloat, y: CGFloat) {
        super.init(x: x, y: y, w: 20, h: 20, file: "enemy00.png", type: Type.ENEMY)
        calculateNextTarget()
    }
    
    func calculateNextTarget() {
        let points = [
            pos + CGPoint(x: 40, y: 0),
            pos + CGPoint(x: -40, y: 0),
            pos + CGPoint(x: 0, y: 40),
            pos + CGPoint(x: 0, y: -40)
        ]
        var min: CGPoint?, minDistance = CGFloat(Int.max)
        for var i = 0, l = points.count; i < l; i++ {
            var dist = distance(scene.p.pos, points[i])
            if dist < minDistance {
                var tempPos = pos
                pos = points[i]
                if getCollisionsOfType(.SOLID).count == 0 {
                    min = points[i]
                    minDistance = dist
                }
                pos = tempPos
            }
        }
        if let m = min {
            var closest: Object?, closestDistance = CGFloat(Int.max)
            for obj in scene.objs {
                var dist = distance(obj.pos, m)
                if (obj is Road || obj is Tree) && dist < closestDistance {
                    closest = obj
                    closestDistance = dist
                }
            }
            if let c = closest {
                target = c
            }
        }
        if let t = target {
            sprite.runAction(SKAction.rotateToAngle(atan2(t.y - y, t.x - x) + CGFloat(M_PI_2), duration: NSTimeInterval(0)))
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        sprite.zPosition = -y
        if let t = target {
            if distance(pos, t.pos) < 10 {
                calculateNextTarget()
            }
            vel = normalize(t.pos - pos) * speed
        }
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