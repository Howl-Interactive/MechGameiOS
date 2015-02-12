//
//  Object.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 2/11/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class Object {
    
    var sprite: SKSpriteNode
    var x: CGFloat { get { return sprite.position.x } set(value) { sprite.position.x = value } }
    var y: CGFloat { get { return sprite.position.y } set(value) { sprite.position.y = value } }
    var pos: CGPoint { get { return sprite.position } set(value) { sprite.position = value } }
    
    var size: CGSize
    
    init(x: CGFloat, y: CGFloat, w: CGFloat = -1, h: CGFloat = -1, file: String) {
        sprite = SKSpriteNode(imageNamed: file)
        sprite.position = CGPoint(x: x, y: y)
        if let textureSize: CGSize = sprite.texture?.size() {
            let aspectRatio = textureSize.width / textureSize.height
            sprite.size = CGSize(width: 40, height: 40 / aspectRatio)
        }
        else {
            sprite.size = CGSize(width:40, height:40)
        }
        
        size = w == -1 || h == -1 ? sprite.size : CGSize(width: w, height: h)
    }
    
    func update(currentTime: CFTimeInterval) {
        move(y: 0)
    }
    
    func move(x: CGFloat = 0, y: CGFloat = 0) {
        self.x += x
        self.y += y
    }
    
    func move(point: CGPoint) {
        move(x: point.x, y: point.y)
    }
    
    func onTouch(touch: CGPoint) { }
}