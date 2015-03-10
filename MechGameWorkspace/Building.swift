//
//  Building.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 2/11/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class Building : Object {
    
    let numBuildingImages: UInt32 = 5
    
    init(x: CGFloat, y: CGFloat) {
        super.init(x: x, y: y, w: 40, h: 40, keepImageSize: true, file: "building0" + String(arc4random_uniform(numBuildingImages) + 1) + ".png", type: Type.SOLID)
        sprite.zPosition = -y
    }
    
    override func collision(obj: Object) {
        switch obj.type {
        case .FRIENDLY:
            isAlive = false
            scene.addObject(Road(x: x, y: y))
            break;
        default:
            break;
        }
    }
}