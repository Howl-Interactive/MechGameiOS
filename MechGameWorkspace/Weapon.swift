//
//  Weapon.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 4/19/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class Weapon {
    
    var cooldown: CGFloat = 0, fireRate: CGFloat
    
    init(fireRate: CGFloat) {
        self.fireRate = fireRate
    }
    
    func update(#x: CGFloat, y: CGFloat, target: Object?) { }
}