//
//  Laser.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 2/14/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class Laser : Object {
    
    var frame = 1
    let numFrames = 9
    let angle: CGFloat
    
    init(x: CGFloat, y: CGFloat, extraDamage: Bool, target: CGFloat) {
        var length: CGFloat = 1
        var width: CGFloat = extraDamage ? 20 : 10
        angle = target
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
                //print("LASER COLLISION DETECTION PROBLEM")
                break
            }
        }
        if collisions.count != 0 {
            collision(collisions[0])
        }
        damage = extraDamage ? 100 : 50
        resize(width, height: length)
    }
    
    convenience init(x: CGFloat, y: CGFloat, extraDamage: Bool, target: Object) {
        self.init(x: x, y: y, extraDamage: extraDamage, target: atan2(target.y - y, target.x - x))
    }
    
    var counter = 0
    override func update(currentTime: CFTimeInterval) {
        super.update(currentTime)
        type = Type.NONE
        if frame == numFrames {
            gameScene.removeObject(self)
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
            gameScene.addChild(sprite)
        }
    }
    
    override func collision(obj: Object) {
        switch obj.type {
        case .SOLID:
            obj.takeDamage(self)
            gameScene.addObject(Explosion(x: obj.x, y: obj.y, numExplosions: 2))
            break
        case .ENEMY:
            obj.takeDamage(self)
            gameScene.addObject(Explosion(x: x2!, y: y2!, numExplosions: 2))
            break
        default:
            break
        }
    }
}