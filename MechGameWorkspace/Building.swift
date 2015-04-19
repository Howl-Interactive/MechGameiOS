//
//  Building.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 2/11/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class Building : Object {
    
    var spazTime = 0
    
    var flickerCounter = 0

    let numBuildingImages: UInt32 = 5
    
    init(x: CGFloat, y: CGFloat) {
        super.init(x: x, y: y, w: 40, h: 40, keepImageSize: true, file: "building0" + String(arc4random_uniform(numBuildingImages) + 1) + ".png", type: Type.SOLID)
        health = 150
        sprite.color = DARKRED
    }
    
    override func update(currentTime: NSTimeInterval) {
        if invulnerable != 0 { invulnerable-- }
        if y < -200 {
            isAlive = false
        }
        if spazTime-- > 0 {
            if spazTime % 2 == 1 {
                sprite.runAction(SKAction.hide())
            }
            else {
                sprite.runAction(SKAction.unhide())
            }
        }
        if health < 150 && health > 0 {
            if ((++flickerCounter * 100) % Int(CGFloat(health) / 10.0 * 100)) / 100 <= 1 {
                sprite.colorBlendFactor = 1.0
            }
            else {
                sprite.colorBlendFactor = 0.0
            }
        }
        sprite.zPosition = -y
    }
    
    /*override func collision(obj: Object) {
        switch obj.type {
        case .FRIENDLY:
            takeDamage(obj)
            scene.addObject(Road(x: x, y: y))
            break;
        default:
            break;
        }
    }*/
    
    override func takeDamage(obj: Object) {
        super.takeDamage(obj)
        if !isAlive {
            scene.addObject(Tree(x: x, y: y))
            if arc4random_uniform(5) == 0 {
                scene.addObject(Pickup(x: x, y: y))
            }
        }
    }
}