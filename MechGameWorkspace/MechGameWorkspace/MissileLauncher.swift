//
//  Missile.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 4/26/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class MissileLauncher : Weapon {
    
    var burstNumber = 1, shotsPerBurst = 2, burstCooldown = 0, burstCooldownTime = 3, sideShots = false
    
    init() {
        super.init(fireRate: 7, weaponType: .MISSILE)
    }
    
    override func update(#x: CGFloat, y: CGFloat, target: Object?) {
        cooldown--
        if let t = target where cooldown <= 0 {
            if burstNumber <= shotsPerBurst {
                if burstCooldown-- == 0 {
                    gameScene.addObject(Missile(x: x, y: y, target: t))
                    if sideShots && arc4random_uniform(2) == 0 {
                        var angle = atan2(t.pos.y - y, t.pos.x - x)
                        gameScene.addObject(Missile(x: x, y: y, target: t, vel: CGPoint(x: cos(angle + CGFloat(M_PI_2)), y: sin(angle + CGFloat(M_PI_2))) * 3))
                        gameScene.addObject(Missile(x: x, y: y, target: t, vel: CGPoint(x: cos(angle - CGFloat(M_PI_2)), y: sin(angle - CGFloat(M_PI_2))) * 3))
                    }
                    audioController.play("shot02-2.wav")
                    burstCooldown = burstCooldownTime
                    burstNumber++
                }
            }
            else {
                cooldown = fireRate
                burstNumber = 1
            }
        }
    }
    
    override func upgrade() {
        switch ++level {
        case 1:
            shotsPerBurst++
            break
        case 2:
            fireRate -= 3
            burstCooldownTime--
            shotsPerBurst++
            break
        case 3:
            sideShots = true
            break
        case 4:
            level--
            break
        default:
            break
        }
    }
}