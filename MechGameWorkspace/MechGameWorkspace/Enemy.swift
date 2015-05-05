
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
    
    var cooldown = 60, fireRate = 60
    
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
            var dist = distance(gameScene.p.pos, points[i])
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
            for obj in gameScene.objs {
                var dist = distance(obj.pos, m)
                if (obj is Road || obj is Tree || obj is DestroyedTile) && dist < closestDistance {
                    closest = obj
                    closestDistance = dist
                }
            }
            if let c = closest {
                target = c
            }
        }
        sprite.runAction(SKAction.rotateToAngle(atan2(gameScene.p.y - y, gameScene.p.x - x) + CGFloat(M_PI_2), duration: NSTimeInterval(0)))
    }
    
    override func update(currentTime: CFTimeInterval) {
        sprite.zPosition = -y
        if let t = target {
            if distance(pos, t.pos) < 10 {
                calculateNextTarget()
            }
            vel = normalize(t.pos - pos) * speed
        }
        if cooldown-- == 0 {
            gameScene.addObject(EnemyBullet(x: x, y: y))
            audioController.play("shot03-2.wav")
            cooldown = fireRate
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
            if gameScene.p.invulnerable == 0 {
                gameScene.p.spaz()
            }
            obj.takeDamage(self)
            break
        case .FRIENDLY:
            takeDamage(obj)
            break
        default:
            break
        }
    }
    
    override func destroy() {
        ui.addChild(AnimatedText(x: x, y: y, text: "+100"))
        enemiesDestroyed++
    }
}