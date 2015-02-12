//
//  Constants.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 2/11/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

private let screenSize: CGRect = UIScreen.mainScreen().bounds
let WIDTH = screenSize.width
let HEIGHT = screenSize.height

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