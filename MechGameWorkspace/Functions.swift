//
//  Functions.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 2/17/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

/*======================================================
POINT CALCULATIONS
======================================================*/

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func /(left: CGPoint, right: CGFloat) -> CGPoint {
    if right == 0 {
        println("DIVIDE BY ZERO ERROR")
        return CGPoint()
    }
    return CGPoint(x: left.x / right, y: left.y / right)
}

func *(left:CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x * right, y: left.y * right)
}

func length(point: CGPoint) -> CGFloat {
    return sqrt(pow(point.x, 2) + pow(point.y, 2))
}

func distance(p1: CGPoint, p2: CGPoint) -> CGFloat {
    return length(p1 - p2)
}

func normalize(point: CGPoint) -> CGPoint {
    return point / length(point)
}

/*======================================================
COLLISION
======================================================*/

func collisionPoint(point: CGPoint, obj: Object) -> Bool {
    return obj.x - obj.w / 2 < point.x && obj.x + obj.w / 2 > point.x && obj.y - obj.h / 2 < point.y && obj.y + obj.h / 2 > point.y
}

func collisionRect(obj1: Object, obj2: Object) -> Bool {
    return obj1.x - obj1.w / 2 < obj2.x + obj2.w / 2 &&
        obj1.x + obj1.w / 2 > obj2.x - obj2.w / 2 &&
        obj1.y - obj1.h / 2 < obj2.y + obj2.h / 2 &&
        obj1.y + obj1.h / 2 > obj2.y - obj2.h / 2
}

func collisionLine(#x1: CGFloat, #y1: CGFloat, #x2: CGFloat, #y2: CGFloat, #x3: CGFloat, #y3: CGFloat, #x4: CGFloat, #y4: CGFloat) -> Bool {
    var denom = ((y4 - y3) * (x2 - x1)) -	((x4 - x3) * (y2 - y1))
    if denom == 0 {
        return false
    }
    else {
        var ua = (((x4 - x3) * (y1 - y3)) - ((y4 - y3) * (x1 - x3))) / denom
        var ub = (((x2 - x1) * (y1 - y3)) - ((y2 - y1) * (x1 - x3))) / denom
        return ua >= 0 && ua <= 1 && ub >= 0 && ub <= 1
    }
}

func collisionLine(#x1: CGFloat, #y1: CGFloat, #x2: CGFloat, #y2: CGFloat, #obj: Object) -> Bool {
    return
        collisionLine(x1: x1, y1: y1, x2: x2, y2: y2, x3: obj.x - obj.w / 2, y3: obj.y - obj.h / 2, x4: obj.x + obj.w / 2, y4: obj.y - obj.h / 2) ||
        collisionLine(x1: x1, y1: y1, x2: x2, y2: y2, x3: obj.x - obj.w / 2, y3: obj.y - obj.h / 2, x4: obj.x - obj.w / 2, y4: obj.y + obj.h / 2) ||
        collisionLine(x1: x1, y1: y1, x2: x2, y2: y2, x3: obj.x + obj.w / 2, y3: obj.y - obj.h / 2, x4: obj.x + obj.w / 2, y4: obj.y + obj.h / 2) ||
        collisionLine(x1: x1, y1: y1, x2: x2, y2: y2, x3: obj.x - obj.w / 2, y3: obj.y + obj.h / 2, x4: obj.x + obj.w / 2, y4: obj.y + obj.h / 2)
}

func collisionLine(#line: Object, #rect: Object) -> Bool {
    switch (line.x2, line.y2) {
    case let (.Some(x2), .Some(y2)):
        return collisionLine(x1: line.x, y1: line.y, x2: x2, y2: y2, obj: rect)
    default:
        return false
    }
}

/*======================================================
MISC
======================================================*/

func contains(objs: [Object], obj: Object) -> Bool {
    for obj2 in objs {
        if obj === obj2 {
            return true
        }
    }
    return false
}