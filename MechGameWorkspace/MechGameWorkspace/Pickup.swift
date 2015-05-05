//
//  Pickup.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 4/5/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class Pickup : Object {
    
    var weaponType: WeaponType
    
    init(x: CGFloat, y: CGFloat) {
        var typeNum = arc4random_uniform(5)
        weaponType = typeNum == 0 ? .CANNON : typeNum == 1 ? .LASER : typeNum == 2 ? .MISSILE : typeNum == 3 ? .AIRSTRIKE : .SHIELD
        var pickupImage = typeNum == 0 ? "cannon_icon.png" : typeNum == 1 ? "lazer_icon.png" : typeNum == 2 ? "missile_icon.png" : typeNum == 3 ? "air_icon.png" : "shield_icon.png"
        super.init(x: x, y: y, w: 40, h: 40, keepImageSize: true, file: pickupImage, type: .PICKUP)
        sprite.zPosition = -y
    }
    
    override func update(currentTime: CFTimeInterval) {
        sprite.zPosition = -y
    }
    
    override func takeDamage(obj: Object) {
        isAlive = false
    }
}