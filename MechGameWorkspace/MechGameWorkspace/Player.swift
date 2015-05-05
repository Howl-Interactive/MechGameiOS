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
    
//    var weapon: Weapon = LaserGun()
    var weapon: Weapon = Cannon()
//    var weapon: Weapon = MissileLauncher()
    
    var shield: Shield?
    
    var dodging = false, dodgeTime = 8, dodgeCounter = 0
    
    init(x: CGFloat, y: CGFloat) {
        super.init(x: x, y: y, w: 20, h: 20, file: "player00.png", type: Type.PLAYER)
        invulnerableTime = 50
        health = 250
        sprite.zPosition = -5001
    }
    
    override func update(currentTime: CFTimeInterval) {
        sprite.zPosition = -y
        super.update(currentTime)
        if !dodging {
            if y < 0 {
                dodge(CGPoint(x: 0, y: 1))
                sprite.runAction(SKAction.rotateToAngle(0, duration: 0))
            }
            if x < 0 {
                dodge(CGPoint(x: 1, y: 0))
                sprite.runAction(SKAction.rotateToAngle(-CGFloat(M_PI_2), duration: 0))
            }
            if x > WIDTH {
                dodge(CGPoint(x: -1, y: 0))
                sprite.runAction(SKAction.rotateToAngle(CGFloat(M_PI_2), duration: 0))
            }
            if let t = shootTarget {
                sprite.runAction(SKAction.rotateToAngle(atan2(t.y - y, t.x - x) - CGFloat(M_PI_2), duration: NSTimeInterval(0)))
            }
            else if let t = target {
                sprite.runAction(SKAction.rotateToAngle(atan2(t.y - y, t.x - x) - CGFloat(M_PI_2), duration: NSTimeInterval(0)))
            }
        }
        else {
            if dodgeCounter-- <= 0 {
                dodging = false
                target = nil
                vel = CGPoint.zeroPoint
            }
        }
        weapon.update(x: x, y: y, target: shootTarget)
    }
    
    override func move() {
        if !dodging {
            if let t = target {
                vel = normalize(t.pos - pos) * SPEED
                super.move()
                if distance(t.pos, pos) < 5 {
                    target = nil
                }
            }
            else {
                vel = CGPoint.zeroPoint
            }
        }
        else {
            pos += vel
            handleCollisions()
            target = nil
        }
    }
    
    func onTouch(touch: CGPoint) {
        if !dodging {
            var newTarget, newShootTarget: Object?
            for obj in gameScene.objs {
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
    }
    
    func spaz() {
        if let s = shield {
            s.spazTime = invulnerableTime / 2
        }
        else {
            var spazTime = invulnerableTime / 2
            for object in gameScene.objs {
                if object is Building {
                    (object as! Building).spazTime = spazTime
                }
                if object is Road {
                    (object as! Road).spazTime = spazTime
                }
            }
            gameScene.background.spazTime = spazTime
        }
    }
    
    func dodge(direction: CGPoint) {
        dodging = true
        dodgeCounter = dodgeTime
        vel = direction * 10
    }
    
    func pickup(obj: Pickup) {
        if obj.weaponType == weapon.weaponType {
            ui.addChild(AnimatedText(x: x, y: y, text: weapon.level == 3 ? "MAX" : "+1"))
            weapon.upgrade()
        }
        else {
            switch obj.weaponType {
            case .CANNON:
                weapon = Cannon()
                break
            case .MISSILE:
                weapon = MissileLauncher()
                break
            case .LASER:
                weapon = LaserGun()
                break
            case .AIRSTRIKE:
                for var i = 0; i < 3; i++ {
                    gameScene.addObject(Airstrike(x: CGFloat(arc4random_uniform(UInt32(WIDTH))), y: CGFloat(arc4random_uniform(UInt32(HEIGHT / 2))) + HEIGHT / 2, delay: 10 * i))
                }
                break
            case .SHIELD:
                if let s = shield {
                    s.destroy()
                    s.isAlive = false
                }
                shield = Shield()
                gameScene.addObject(shield!)
            }
        }
        obj.takeDamage(obj)
    }
    
    override func collision(obj: Object) {
        switch obj.type {
        case .SOLID:
            if !dodging {
                solidCollision(obj)
            }
            else {
                obj.isAlive = false
                obj.destroy()
                if invulnerable == 0 {
                    spaz()
                    audioController.play("shot02-2.wav")
                }
                takeDamage(obj)
            }
            break
        case .ENEMY:
            if invulnerable == 0 {
                spaz()
                audioController.play("shot02-2.wav")
            }
            takeDamage(obj)
            break
        case .PICKUP:
            pickup(obj as! Pickup)
            break
        default:
            break
        }
    }
    
    override func solidCollision(obj: Object) {
        super.solidCollision(obj)
        target = nil
    }
    
    override func takeDamage(obj: Object) {
        if let s = shield {
            s.takeDamage(obj)
            invulnerable = invulnerableTime
        }
        else {
            super.takeDamage(obj)
        }
    }
}