//
//  Laser.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 2/14/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit
import Darwin

class Laser : Object {
    
    init(x: CGFloat, y: CGFloat, target: Object) {
        var length:CGFloat = 1//distance(CGPoint(x: x, y: y), target.pos)
        var width: CGFloat = 3
        super.init(x: x, y: y, w: width, h: length, file: "", color: UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0), type: Type.FRIENDLY, collisionType: CollisionType.LINE)
        var angle = atan2(target.y - y, target.x - x)
        sprite.anchorPoint = CGPoint(x: 0, y: 0)
        sprite.runAction(SKAction.rotateToAngle(angle - CGFloat(M_PI_2), duration: NSTimeInterval(0)))
        x2 = x + length * cos(angle) - width * sin(angle)
        y2 = y + length * sin(angle) + width * cos(angle)
        
        var collisions = getCollisionsOfType(Type.SOLID)
        var collisions2 = getCollisionsOfType(Type.ENEMY)
        for var i = 0; i < collisions2.count; i++ {
            collisions.append(collisions2[i])
        }
        while collisions.count == 0 {
            length += 10
            x2 = x + length * cos(angle) - width * sin(angle)
            y2 = y + length * sin(angle) + width * cos(angle)
            collisions = getCollisionsOfType(Type.SOLID)
            collisions2 = getCollisionsOfType(Type.ENEMY)
            for var i = 0; i < collisions2.count; i++ {
                collisions.append(collisions2[i])
            }
            if length > HEIGHT {
                print("LASER COLLISION DETECTION PROBLEM")
                break
            }
        }
        if collisions.count != 0 {
            collision(collisions[0])
        }
        resize(width, height: length)
    }
    
    var counter = 0
    override func update(currentTime: CFTimeInterval) {
        super.update(currentTime)
        if counter++ > 5 {
            scene.removeObject(self)
        }
    }
    
    override func collision(obj: Object) {
        switch obj.type {
        case .SOLID:
            obj.isAlive = false
            scene.addObject(Tree(x: obj.x, y: obj.y))
            scene.addObject(Explosion(x: x2!, y: y2!))
            break
        case .ENEMY:
            obj.isAlive = false
            scene.addObject(Explosion(x: x2!, y: y2!))
            break
        default:
            break
        }
    }
}