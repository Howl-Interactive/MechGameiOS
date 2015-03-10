
//
//  Enemy.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 2/19/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class Enemy : Object {
    
    init(x: CGFloat, y: CGFloat) {
        super.init(x: x, y: y, w: 20, h: 20, file: "enemy00.png", type: Type.ENEMY)
        vel = CGPoint(x: 0, y: -5)
    }
    
    override func update(currentTime: CFTimeInterval) {
        super.update(currentTime)
        if y < -200 || y > HEIGHT + 200 {
            isAlive = false
        }
    }
    
    override func collision(obj: Object) {
        switch obj.type {
        case .PLAYER:
            obj.isAlive = false
            break
        case .FRIENDLY:
            isAlive = false
            break
        default:
            break
        }
    }
}