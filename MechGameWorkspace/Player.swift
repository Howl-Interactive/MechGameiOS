//
//  Player.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 2/11/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class Player : Object {
    
    var vel = CGPoint()
    let SPEED: CGFloat = 5.0
    var target: CGPoint?
    
    init(x: CGFloat, y: CGFloat) {
        super.init(x: x, y: y, file: "building01.png")
        sprite.zPosition = 1
    }
    
    override func update(currentTime: CFTimeInterval) {
        super.update(currentTime)
        if let t = target {
            move(vel)
            if distance(t, pos) < 5 {
                target = nil
            }
        }
        else {
            vel = CGPoint()
        }
    }
    
    override func onTouch(touch: CGPoint) {
        if distance(touch, pos) < 5 {
            return
        }
        vel = normalize(touch - pos) * SPEED
        target = touch
    }
}
