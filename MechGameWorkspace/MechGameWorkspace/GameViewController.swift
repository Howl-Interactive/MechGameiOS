//
//  GameViewController.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 2/11/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import UIKit
import SpriteKit

var gameScene: GameScene!
var ui: UI!
var audioController: AudioController!

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        skView.showsFPS = true
        
        audioController = AudioController()
        
        gameScene = GameScene(size: CGSize(width: WIDTH, height: HEIGHT))//skView.bounds.size)
        gameScene.scaleMode = .AspectFill
        
        skView.presentScene(gameScene)
        
        ui = UI()
        gameScene.addChild(ui)
        
        var up = UISwipeGestureRecognizer(target: self, action: "swipe:")
        up.direction = .Up
        skView.addGestureRecognizer(up)
        var down = UISwipeGestureRecognizer(target: self, action: "swipe:")
        down.direction = .Down
        skView.addGestureRecognizer(down)
        var left = UISwipeGestureRecognizer(target: self, action: "swipe:")
        left.direction = .Left
        skView.addGestureRecognizer(left)
        var right = UISwipeGestureRecognizer(target: self, action: "swipe:")
        right.direction = .Right
        skView.addGestureRecognizer(right)
    }
    
    func swipe(sender: UISwipeGestureRecognizer) {
        gameScene.swipe(sender)
        if sender.state == UIGestureRecognizerState.Ended {
            gameScene.onTouchRelease()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func calcPoint(touches: NSSet) {
        var touch = (touches.anyObject()! as! UITouch).locationInView(self.view)
        var translatedTouch = CGPoint(x: touch.x * WIDTH / TRUE_WIDTH, y: touch.y * HEIGHT / TRUE_HEIGHT)
        gameScene.onTouch(CGPoint(x: translatedTouch.x, y: HEIGHT - translatedTouch.y))
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        calcPoint(touches)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        calcPoint(touches)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        gameScene.onTouchRelease()
    }
}
