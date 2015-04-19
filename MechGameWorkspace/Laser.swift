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
    
    var frame = 1
    let numFrames = 9
    let angle: CGFloat
    
    init(x: CGFloat, y: CGFloat, target: Object) {
        var length: CGFloat = 1
        var width: CGFloat = 20
        angle = atan2(target.y - y, target.x - x)
        super.init(x: x, y: y, w: 1, h: length, file: "lazer_beam01.png", type: Type.FRIENDLY, collisionType: CollisionType.LINE)
        sprite.anchorPoint = CGPoint(x: 0.5, y: 0)
        sprite.zPosition = 1
        sprite.runAction(SKAction.rotateToAngle(angle - CGFloat(M_PI_2), duration: NSTimeInterval(0)))
        sprite.color = COLORS[Int(arc4random_uniform(UInt32(COLORS.count)))]
        sprite.colorBlendFactor = 1.0
        x2 = x + length * cos(angle) - 0 * sin(angle)
        y2 = y + length * sin(angle) + 0 * cos(angle)
        var collisions = getCollisionsOfType(Type.SOLID)
        var collisions2 = getCollisionsOfType(Type.ENEMY)
        for var i = 0; i < collisions2.count; i++ {
            collisions.append(collisions2[i])
        }
        while collisions.count == 0 {
            length += 10
            x2 = x + length * cos(angle) - 0 * sin(angle)
            y2 = y + length * sin(angle) + 0 * cos(angle)
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
        type = Type.NONE
        if frame == numFrames {
            scene.removeObject(self)
        }
        else {
            var tempX = x, tempY = y
            sprite.removeFromParent()
            sprite = SKSpriteNode(imageNamed: "lazer_beam0\(++frame).png")
            sprite.position = CGPoint(x: tempX, y: tempY)
            sprite.anchorPoint = CGPoint(x: 0.5, y: 0)
            sprite.zPosition = 1
            sprite.runAction(SKAction.rotateToAngle(angle - CGFloat(M_PI_2), duration: NSTimeInterval(0)))
            sprite.xScale = size.width / sprite.size.width
            sprite.yScale = size.height / sprite.size.height
            sprite.color = COLORS[Int(arc4random_uniform(UInt32(COLORS.count)))]
            sprite.colorBlendFactor = 1.0
            scene.addChild(sprite)
        }
    }
    
    override func collision(obj: Object) {
        switch obj.type {
        case .SOLID:
            obj.takeDamage(self)
            scene.addObject(Explosion(x: obj.x, y: obj.y))
            break
        case .ENEMY:
            obj.takeDamage(self)
            scene.addObject(Explosion(x: x2!, y: y2!))
            break
        default:
            break
        }
    }
}