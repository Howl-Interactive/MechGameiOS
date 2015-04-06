//
//  Background.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 3/31/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class Background : SKSpriteNode {
    
    var spazTime = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init(texture: nil, color: UIColor.whiteColor(), size: CGSize(width: WIDTH, height: HEIGHT))
        anchorPoint = CGPoint.zeroPoint
        zPosition = -10000
        color = RED
    }
    
    func update() {
        if spazTime > 0 {
            spazTime--
//            color = COLORS[Int(arc4random_uniform(UInt32(COLORS.count)))]
        }
    }
}