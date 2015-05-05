//
//  DestroyedTile.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 5/3/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class DestroyedTile : Object {
    
    init(obj: Object) {
        super.init(x: obj.x, y: obj.y, w: 40, h: 40, keepImageSize: true, file: obj is Building ? "buildingdestroyed.png" : "roaddest.png", type: .NONE)
        if obj is Road {
            sprite.hidden = true
        }
        sprite.zPosition = -y
    }
    
    override func update(currentTime: CFTimeInterval) {
        sprite.zPosition = -y
    }
}