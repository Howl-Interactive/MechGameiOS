//
//  GameViewController.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 2/11/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import UIKit
import SpriteKit

var scene: GameScene!

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as SKView
        skView.multipleTouchEnabled = false
        
        skView.showsFPS = true
        
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func calcPoint(touches: NSSet) {
        var touch = (touches.anyObject()! as UITouch).locationInView(self.view)
        scene.onTouch(CGPoint(x: touch.x, y: HEIGHT - touch.y))
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        calcPoint(touches)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        calcPoint(touches)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        scene.onTouchRelease()
    }
}
