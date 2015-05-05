//
//  Cannon.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 4/26/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class Cannon : Weapon {
    
    var numShots = 1
    
    init() {
        super.init(fireRate: 4, weaponType: .CANNON)
    }
    
    override func update(#x: CGFloat, y: CGFloat, target: Object?) {
        cooldown--
        if let t = target where cooldown <= 0 {
            if numShots == 1 || numShots == 3 {
                gameScene.addObject(Bullet(x: x, y: y, target: t))
            }
            if numShots == 2 || numShots == 3 {
                var angle = atan2(t.pos.y - y, t.pos.x - x)
                gameScene.addObject(Bullet(x: x + cos(angle + CGFloat(M_PI_2)) * 10, y: y + cos(angle + CGFloat(M_PI_2) * 10), target: t))
                gameScene.addObject(Bullet(x: x + cos(angle - CGFloat(M_PI_2)) * 10, y: y + cos(angle - CGFloat(M_PI_2) * 10), target: t))
            }
            audioController.play("shot02-2.wav")
            cooldown = fireRate
        }
    }
    
    override func upgrade() {
        switch ++level {
        case 1:
            numShots++
            break
        case 2:
            fireRate /= 2
            break
        case 3:
            numShots++
            break
        case 4:
            level--
            break
        default:
            break
        }
    }
}