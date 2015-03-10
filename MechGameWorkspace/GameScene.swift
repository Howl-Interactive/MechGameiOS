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
    
    let tileSize: CGFloat = 40, cols: CGFloat = 9, rows: CGFloat = 15, yScroll: CGFloat = -2
    var scrollOffset: CGFloat = 0
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    override init(size: CGSize) {
        p = Player(x: WIDTH / 2, y: 200)
        super.init(size: size)
        addObject(p)
        addSection(0)
        addSection(tileSize * rows)
    }
    
    func addSection(offset: CGFloat) {
        for var j: CGFloat = rows; j >= 0; j-- {
            for var i: CGFloat = 0; i < cols; i++ {
                if j % 3 == 0 {
                    if i % 3 == 1 {
                        addObject(Road(x: i * 40, y: j * 40 + offset))
                    }
                    else {
                        addObject(Road(x: i * 40, y: j * 40 + offset, vertical: false))
                    }
                }
                else if i % 3 == 1 {
                    addObject(Road(x: i * 40, y: j * 40 + offset, vertical: true))
                }
                else if arc4random_uniform(4) == 0 {
                    addObject(Tree(x: i * 40, y: j * 40 + offset))
                }
                else {
                    addObject(Building(x: i * 40, y: j * 40 + offset))
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
    
    func removeObject(index: Int) {
        objs[index].sprite.removeFromParent()
        objs.removeAtIndex(index)
    }
    
    var counter = 0
    let spawnTimer = 100
    override func update(currentTime: CFTimeInterval) {
        if counter-- == 0 {
            addObject(Enemy(x: CGFloat(40 + arc4random_uniform(3) * 120), y: HEIGHT + 100))
            counter = spawnTimer
        }
        if let t = touch {
            p.onTouch(t)
        }
        for obj in objs {
            obj.update(currentTime)
        }
        for var i = objs.count - 1; i >= 0; i-- {
            if !objs[i].isAlive {
                removeObject(i)
            }
        }
        for obj in objs {
            obj.y += yScroll
        }
        scrollOffset += yScroll
        if abs(scrollOffset) >= tileSize * rows {
            addSection(tileSize * rows - (abs(scrollOffset) - tileSize * rows))
            scrollOffset = (abs(scrollOffset) - tileSize * rows) * (scrollOffset > 0 ? 1 : -1)
        }
    }
    
    func onTouch(point: CGPoint) {
        touch = point
    }
    
    func onTouchRelease() {
        touch = nil
    }
}