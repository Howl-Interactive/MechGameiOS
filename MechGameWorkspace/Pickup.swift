//
//  Pickup.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 4/5/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class Pickup : Object {
    
    enum PickupType { case CANNON, LASER, MISSILE }
    var pickupType: PickupType
    
    init(x: CGFloat, y: CGFloat) {
        var typeNum = arc4random_uniform(3)
        pickupType = typeNum == 0 ? .CANNON : typeNum == 1 ? .LASER : .MISSILE
        var pickupImage = typeNum == 0 ? "cannon_icon.png" : typeNum == 1 ? "lazer_icon.png" : "missile_icon.png"
        super.init(x: x, y: y, w: 40, h: 40, keepImageSize: true, file: pickupImage, type: .PICKUP)
    }
    
    override func update(currentTime: CFTimeInterval) {
        sprite.zPosition = -y
    }
}