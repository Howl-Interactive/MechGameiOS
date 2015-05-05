//
//  LaserGun.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 4/19/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class LaserGun : Weapon {
    
    init() {
        super.init(fireRate: 10)
    }
    
    override func update(#x: CGFloat, y: CGFloat, target: Object?) {
        cooldown--
        if let t = target where cooldown <= 0 {
            scene.addObject(Laser(x: x, y: y, target: t))
            cooldown = fireRate
        }
    }
}