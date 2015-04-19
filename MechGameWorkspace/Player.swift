//
//  Player.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 2/11/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class Player : Object {
    
    override var y: CGFloat { get { return super.y } set(value) { sprite.position.y = value; sprite.zPosition = -y } }
    
    let SPEED: CGFloat = 5.0
    weak var target: Object?, shootTarget: Object?
    var cooldown = 0
    let FIRE_RATE = 10
    
    init(x: CGFloat, y: CGFloat) {
        super.init(x: x, y: y, w: 20, h: 20, file: "player00.png", type: Type.PLAYER)
    }
    
    override func update(currentTime: CFTimeInterval) {
        sprite.zPosition = -y
        super.update(currentTime)
        if let t = shootTarget {
            sprite.runAction(SKAction.rotateToAngle(atan2(t.y - y, t.x - x) - CGFloat(M_PI_2), duration: NSTimeInterval(0)))
        }
        else if let t = target {
            sprite.runAction(SKAction.rotateToAngle(atan2(t.y - y, t.x - x) - CGFloat(M_PI_2), duration: NSTimeInterval(0)))
        }
        shoot()
        if cooldown != 0 {
            cooldown--
        }
    }
    
    func shoot() {
        if let t = shootTarget {
            if cooldown == 0 {
                scene.addObject(Laser(x: x, y: y, target: t))
                cooldown = FIRE_RATE
            }
        }
    }
    
    override func move() {
        if let t = target {
            vel = normalize(t.pos - pos) * SPEED
            super.move()
            if distance(t.pos, pos) < 5 {
                target = nil
            }
        }
        else {
            vel = CGPoint()
        }
    }
    
    func onTouch(touch: CGPoint) {
        var newTarget, newShootTarget: Object?
        for obj in scene.objs {
            if collisionPoint(touch, obj) {
                if obj.type == Type.ENEMY || obj.type == Type.SOLID {
                    newShootTarget = obj
                }
                else if obj.type == Type.NONE {
                    newTarget = obj
                }
            }
        }
        if let t = newShootTarget {
            shootTarget = newShootTarget
        }
        else if let t = newTarget {
            target = newTarget
        }
    }
    
    func spaz() {
        var spazTime = 7
        for object in scene.objs {
            if object is Building {
                (object as! Building).spazTime = spazTime
            }
            if object is Road {
                (object as! Road).spazTime = spazTime
            }
        }
        scene.background.spazTime = spazTime
    }
    
    override func collision(obj: Object) {
        switch obj.type {
        case .SOLID:
            solidCollision(obj)
            break
        case .ENEMY:
            spaz()
            takeDamage(obj)
            break
        default:
            break
        }
    }
    
    override func solidCollision(obj: Object) {
        super.solidCollision(obj)
        target = nil
    }
}
