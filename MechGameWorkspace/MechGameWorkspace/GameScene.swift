//
//  GameScene.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 2/11/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

let buildingValue = 25, enemyValue = 100
var buildingsDestroyed = 0, enemiesDestroyed = 0

class GameScene: SKScene {
    
    var touch: CGPoint?, buttonActivated = false
    
    var started = false
    
    var objs = [Object]()
    var p: Player, playerDrop: PlayerDrop?
    var background: Background
    
    var tileSize: CGFloat = 40, cols: CGFloat = 9, rows: CGFloat = 15, yScroll: CGFloat = -2
    var scrollOffset: CGFloat = 0
    
    enum Version { case I5, I6, I6P }
    var version: Version
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    override init(size: CGSize) {
        p = Player(x: WIDTH / 2, y: 200)
        background = Background()
        if WIDTH - 320 < 20 {
            version = .I5
        }
        else if WIDTH - 375 < 20 {
            version = .I6
        }
        else if WIDTH - 414 < 20 {
            version = .I6P
        }
        else {
            version = .I5
        }
        super.init(size: size)
        addChild(background)
        addSection(0)
        addSection(tileSize * rows)
    }
    
    func reset() {
        for obj in objs {
            obj.sprite.removeFromParent()
        }
        objs = [Object]()
        p = Player(x: WIDTH / 2, y: 200)
        background.removeFromParent()
        background = Background()
        addChild(background)
        scrollOffset = 0
        touch = nil
        buttonActivated = false
        buildingsDestroyed = 0
        enemiesDestroyed = 0
        counter = 0
        addSection(0)
        addSection(tileSize * rows)
        playerDrop = PlayerDrop(x: WIDTH / 2, y: 200)
        addChild(playerDrop!.sprite)
        p.sprite.zPosition = -5000
    }
    
    func gameOver() {
        gameScene.started = false
        addChild(PlayerDeath(x: p.x, y: p.y))
    }
    
    func addSection(offset: CGFloat) {
        for var j: CGFloat = rows; j >= 0; j-- {
            for var i: CGFloat = 0; i < cols; i++ {
                if version == .I5 {
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
        if started {
            if !paused {
                background.update()
                if counter-- == 0 {
                    addObject(EnemyDrop(x: CGFloat(40 + arc4random_uniform(7) * 40), y: HEIGHT - 100))
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
                        if objs[i] is Player {
                            gameOver()
                        }
                        else {
                            removeObject(i)
                        }
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
            buttonActivated = false
        }
        if let pd = playerDrop {
            pd.update(currentTime)
        }
    }
    
    func togglePause() {
        if started {
            if !paused {
                background.colorBlendFactor = 0
                for obj in objs {
                    if obj is Road {
                        obj.sprite.runAction(SKAction.hide())
                    }
                }
                ui.addChild(ui.pauseScreen)
                runAction(SKAction.waitForDuration(0.01), completion: { self.paused = true })
            }
            else {
                background.colorBlendFactor = 1
                for obj in objs {
                    if obj is Road {
                        obj.sprite.runAction(SKAction.unhide())
                    }
                }
                ui.pauseScreen.removeFromParent()
                self.paused = false
            }
        }
    }
    
    func swipe(sender: UISwipeGestureRecognizer) {
        if started {
            switch sender.direction {
            case UISwipeGestureRecognizerDirection.Up:
                p.dodge(CGPoint(x: 0, y: 1))
                break
            case UISwipeGestureRecognizerDirection.Down:
                p.dodge(CGPoint(x: 0, y: -1))
                break
            case UISwipeGestureRecognizerDirection.Left:
                p.dodge(CGPoint(x: -1, y: 0))
                break
            case UISwipeGestureRecognizerDirection.Right:
                p.dodge(CGPoint(x: 1, y: 0))
                break
            default:
                break
            }
        }
    }
    
    func onTouch(point: CGPoint) {
        if started && !buttonActivated { touch = point }
    }
    
    func onTouchRelease() {
        touch = nil
    }
}