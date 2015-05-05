//
//  Weapon.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 4/19/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

enum WeaponType { case CANNON, LASER, MISSILE, AIRSTRIKE, SHIELD }

class Weapon {
    
    var weaponType: WeaponType
    var cooldown: CGFloat = 0, fireRate: CGFloat
    var level = 0
    
    init(fireRate: CGFloat, weaponType: WeaponType) {
        self.weaponType = weaponType
        self.fireRate = fireRate
    }
    
    func update(#x: CGFloat, y: CGFloat, target: Object?) { }
    func upgrade() { }
}