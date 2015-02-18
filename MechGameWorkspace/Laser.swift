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
        var width: CGFloat = 2
        super.init(x: x, y: y, w: width, h: length, file: "building01.png", type: Type.FRIENDLY, collisionType: CollisionType.LINE)
        var angle = atan2(target.y - y, target.x - x)
        sprite.anchorPoint = CGPoint(x: 0, y: 0)
        sprite.runAction(SKAction.rotateToAngle(angle - CGFloat(M_PI_2), duration: NSTimeInterval(0)))
        x2 = x + length * cos(angle) - width * sin(angle)
        y2 = y + length * sin(angle) + width * cos(angle)
        
        var collisions = getCollisionsOfType(Type.SOLID)
        while collisions.count == 0 {
            length++
            x2 = x + length * cos(angle) - width * sin(angle)
            y2 = y + length * sin(angle) + width * cos(angle)
            collisions = getCollisionsOfType(Type.SOLID)
            if length > HEIGHT {
                print("ERROR")
                break
            }
        }
        resize(width, height: length)
        /*var collisions = getCollisions()
        if collisions.count > 0 {
            var targetObj: Object?, minDistance = CGFloat.max, newDistance: CGFloat
            for obj in collisions {
                newDistance = distance(pos, obj.pos)
                if obj is Building && newDistance < minDistance {
                    minDistance = newDistance
                    targetObj = obj
                }
            }
            if let t = targetObj {
                resize(width, height: distance(CGPoint(x: x, y: y), t.pos))
                x2 = x + length * cos(angle) - width * sin(angle)
                y2 = y + length * sin(angle) + width * cos(angle)
            }
        }*/
    }
    
    var counter = 0
    override func update(currentTime: CFTimeInterval) {
        super.update(currentTime)
        if counter++ > 50 {
            scene.removeObject(self)
        }
    }
    
    
}