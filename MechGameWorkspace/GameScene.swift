//
//  GameScene.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 2/11/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var touch: CGPoint?
    var objs = [Object]()
    var p: Player
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    override init(size: CGSize) {
        p = Player(x: WIDTH / 2, y: 200)
        super.init(size: size)
        addObject(p)
        for var j: CGFloat = 14; j >= 0; j-- {
            for var i: CGFloat = 0; i < 9; i++ {
                if j % 4 == 0 {
                    if i % 3 == 1 {
                        addObject(Road(x: i * 40, y: j * 40))
                    }
                    else {
                        addObject(Road(x: i * 40, y: j * 40, vertical: false))
                    }
                }
                else if i % 3 == 1 {
                    addObject(Road(x: i * 40, y: j * 40, vertical: true))
                }
                else {
                    addObject(Building(x: i * 40, y: j * 40))
                }
            }
        }
    }
    
    func addObject(obj: Object) {
        objs.append(obj)
        addChild(obj.sprite)
    }
    
    func removeObject(obj: Object) {
        obj.sprite.removeFromParent()
        for var i = 0; i < objs.count; i++ {
            if objs[i] === obj {
                objs.removeAtIndex(i)
                break
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        for obj in objs {
            if let t = touch {
                if collisionPoint(t, obj) {
                    obj.onTouch(t)
                }
            }
            obj.update(currentTime)
        }
    }
    
    func onTouch(point: CGPoint) {
        touch = point
    }
    
    func onTouchRelease() {
        touch = nil
    }
}
