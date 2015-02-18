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
    var target: Object?, shootTarget: Object?
    var cooldown = 0
    let FIRE_RATE = 20
    
    init(x: CGFloat, y: CGFloat) {
        super.init(x: x, y: y, w: 20, h: 20, file: "building01.png", type: Type.PLAYER)
        sprite.zPosition = 1
    }
    
    override func update(currentTime: CFTimeInterval) {
        super.update(currentTime)
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
    
    override func collision(obj: Object) {
        if obj.type == Type.SOLID {
            solidCollision()
        }
    }
    
    override func solidCollision() {
        super.solidCollision()
        target = nil
    }
}
