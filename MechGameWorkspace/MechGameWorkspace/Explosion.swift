//
//  Explosion.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 2/18/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class Explosion : Object {
    
    var frame = 0
    let numFrames = 12
    
    var rotation: CGFloat
    let spinAmount: CGFloat = 0.2
    
    let diameter: CGFloat
    
    var num: Int
    let numExplosions: Int
    var originX: CGFloat, originY: CGFloat
    var counter = 0, offset = 1
    
    init(x: CGFloat, y: CGFloat, num: Int = 0, numExplosions: Int = 0) {
        rotation = CGFloat(arc4random_uniform(628)) / CGFloat(100)
        self.diameter = CGFloat(arc4random_uniform(30) + 10)
        self.num = num
        self.numExplosions = numExplosions
        self.originX = x
        self.originY = y
        super.init(x: x + CGFloat(arc4random_uniform(40)) - 20, y: y + CGFloat(arc4random_uniform(40)) - 20, w: diameter, h: diameter, file: "explosion1.png")
        sprite.runAction(SKAction.rotateToAngle(rotation, duration: NSTimeInterval(0)))
        sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sprite.zPosition = 5
    }
    
    override func update(currentTime: CFTimeInterval) {
        if num < numExplosions && ++counter == offset {
            gameScene.addObject(Explosion(x: originX, y: originY, num: num + 1, numExplosions: numExplosions))
        }
        if ++frame == numFrames {
            isAlive = false
            return
        }
        var tempX = x, tempY = y
        sprite.removeFromParent()
        sprite = SKSpriteNode(imageNamed: "explosion" + String(frame) + ".png")
        sprite.position = CGPoint(x: tempX, y: tempY)
        sprite.zPosition = 5
        rotation += spinAmount
        sprite.runAction(SKAction.rotateToAngle(rotation, duration: NSTimeInterval(0)))
        sprite.size = CGSize(width: diameter, height: diameter)
        //sprite.color = COLORS[Int(arc4random_uniform(UInt32(COLORS.count)))]
        //sprite.colorBlendFactor = 1.0
        sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gameScene.addChild(sprite)
    }
}