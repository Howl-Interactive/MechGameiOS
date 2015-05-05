//
//  LaserGun.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 4/19/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class LaserGun : Weapon {
    
    var doubleShot = false, extraDamage = false
    
    init() {
        super.init(fireRate: 15, weaponType: .LASER)
    }
    
    override func update(#x: CGFloat, y: CGFloat, target: Object?) {
        cooldown--
        if let t = target where cooldown <= 0 {
            gameScene.addObject(Laser(x: x, y: y, extraDamage: extraDamage, target: t))
            if doubleShot {
                gameScene.addObject(Laser(x: x, y: y, extraDamage: extraDamage, target: atan2(t.y - y, t.x - x) + CGFloat(M_PI)))
            }
            audioController.play("shot01-2.wav")
            cooldown = fireRate
        }
    }
    
    override func upgrade() {
        switch ++level {
        case 1:
            fireRate -= 2
            break
        case 2:
            fireRate -= 3
            extraDamage = true
            break
        case 3:
            doubleShot = true
            break
        case 4:
            level--
            break
        default:
            break
        }
    }
}