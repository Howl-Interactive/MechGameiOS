//
//  AudioController.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 5/3/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class AudioController {
    
    var music = true, sfx = true
    
    func play(file: String) {
        if sfx {
            gameScene.runAction(SKAction.playSoundFileNamed(file, waitForCompletion: false))
        }
    }
    
    func toggleMusic() {
        music = !music
    }
    
    func toggleSFX() {
        sfx = !sfx
    }
}