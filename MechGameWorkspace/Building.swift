//
//  Building.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 2/11/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class Building : Object {
    
    init(x: CGFloat, y: CGFloat) {
        super.init(x: x, y: y, w: 40, h: 40, keepImageSize: true, file: "building02.png", type: Type.SOLID)
        sprite.zPosition = -y
    }
}