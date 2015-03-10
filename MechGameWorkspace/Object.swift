//
//  Object.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 2/11/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class Object {
    
    enum Type { case NONE, SOLID, PLAYER, FRIENDLY, ENEMY }
    var type: Type
    
    enum CollisionType { case RECTANGULAR, LINE }
    var collisionType: CollisionType
    
    var sprite: SKSpriteNode
    var pos: CGPoint { get { return sprite.position } set(value) { sprite.position = value } }
    var x: CGFloat { get { return sprite.position.x } set(value) { sprite.position.x = value } }
    var y: CGFloat { get { return sprite.position.y } set(value) { sprite.position.y = value } }
    
    var x2, y2: CGFloat?
    
    var vel = CGPoint()
    
    var size: CGSize
    var w: CGFloat { get { return size.width } set(value) { size.width = value } }
    var h: CGFloat { get { return size.height } set(value) { size.height = value } }
    
    var isAlive = true
    
    init(x: CGFloat, y: CGFloat, w: CGFloat = -1, h: CGFloat = -1, keepImageSize: Bool = false, file: String, color: UIColor? = nil, type: Type = Type.NONE, collisionType: CollisionType = CollisionType.RECTANGULAR) {
        self.type = type;
        self.collisionType = collisionType
        if let c = color {
            sprite = SKSpriteNode(color: c, size: CGSize(width: 40, height: 40))
        }
        else {
            sprite = SKSpriteNode(imageNamed: file)
        }
        sprite.position = CGPoint(x: x, y: y)
        sprite.zPosition = -5000;
        if let textureSize: CGSize = sprite.texture?.size() {
            let aspectRatio = textureSize.width / textureSize.height
            sprite.size = CGSize(width: 40, height: ceil(40 / aspectRatio))
        }
        else {
            sprite.size = CGSize(width:40, height:40)
        }
        
        size = w == -1 || h == -1 ? sprite.size : CGSize(width: w, height: h)
        if !keepImageSize {
            sprite.xScale = size.width / sprite.size.width
            sprite.yScale = size.height / sprite.size.height
        }
        sprite.anchorPoint = CGPoint(x: (size.width / 2) / sprite.size.width, y: (size.height / 2) / sprite.size.height)
    }
    
    func resize(width: CGFloat, height: CGFloat) {
        w = width
        h = height
        sprite.xScale = w / (sprite.size.width / sprite.xScale)
        sprite.yScale = h / (sprite.size.height / sprite.yScale)
    }
    
    func update(currentTime: CFTimeInterval) {
        move(vel)
    }
    
    func move(x: CGFloat, y: CGFloat) {
        self.x += x
        self.y += y
    }
    
    func move(point: CGPoint) {
        move()
    }
    
    func move() {
        var xStep = getXStep(), yStep = getYStep()
        for var i: CGFloat = 0; i < max(abs(vel.x), abs(vel.y)); i++ {
            x += xStep * (vel.x > 0 ? 1 : -1)
            y += yStep * (vel.y > 0 ? 1 : -1)
            handleCollisions()
        }
    }
    
    private func getXStep() -> CGFloat {
        return vel.y == 0 ? 1 : abs(vel.x) > abs(vel.y) ? 1 : abs(vel.x / vel.y)
    }
    
    private func getYStep() -> CGFloat {
        return vel.x == 0 ? 1 : abs(vel.y) > abs(vel.x) ? 1 : abs(vel.y / vel.x)
    }
    
    func handleCollisions() {
        var collisions = getCollisions();
        for obj in collisions {
            collision(obj)
        }
    }
    
    func getCollisions() -> [Object] {
        var collisions = [Object]()
        for obj in scene.objs {
            if isColliding(obj) {
                collisions.append(obj)
            }
        }
        return collisions;
    }
    
    func getCollisionsOfType(type: Type) -> [Object] {
        var collisions = getCollisions(), collisionsOfType = [Object]()
        for obj in collisions {
            if obj.type == type {
                collisionsOfType.append(obj)
            }
        }
        return collisionsOfType
    }
    
    func collision(obj: Object) { }
    
    func solidCollision() {
        if vel.x != 0 {
            x -= getXStep() * (vel.x > 0 ? 1 : -1)
            vel.x = 0
        }
        if vel.y != 0 {
            y -= getYStep() * (vel.y > 0 ? 1 : -1)
            vel.y = 0
        }
    }
    
    func isColliding(obj: Object) -> Bool {
        switch (collisionType, obj.collisionType) {
        case (CollisionType.RECTANGULAR, CollisionType.RECTANGULAR):
            return collisionRect(self, obj)
        case (CollisionType.LINE, CollisionType.RECTANGULAR):
            return collisionLine(line: self, rect: obj)
        case (CollisionType.RECTANGULAR, CollisionType.LINE):
            return collisionLine(line: obj, rect: self)
        default:
            return false
        }
    }
}