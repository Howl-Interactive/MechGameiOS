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
    
    init(x: CGFloat, y: CGFloat) {
        rotation = CGFloat(arc4random_uniform(628)) / CGFloat(100)
        super.init(x: x, y: y, w: 60, h: 60, file: "explosion1.png")
        sprite.runAction(SKAction.rotateToAngle(rotation, duration: NSTimeInterval(0)))
    }
    
    override func update(currentTime: CFTimeInterval) {
        if ++frame == numFrames {
            isAlive = false
            return
        }
        var tempX = x, tempY = y
        sprite.removeFromParent()
        sprite = SKSpriteNode(imageNamed: "explosion" + String(frame) + ".png")
        sprite.position = CGPoint(x: tempX, y: tempY)
        sprite.zPosition = -5000;
        sprite.runAction(SKAction.rotateToAngle(rotation, duration: NSTimeInterval(0)))
        if let textureSize: CGSize = sprite.texture?.size() {
            let aspectRatio = textureSize.width / textureSize.height
            sprite.size = CGSize(width: 40, height: ceil(40 / aspectRatio))
        }
        scene.addChild(sprite)
    }
}