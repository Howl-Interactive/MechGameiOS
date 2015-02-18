//
//  Road.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 2/11/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class Road : Object {
    
    init(x: CGFloat, y: CGFloat, vertical: Bool? = nil) {
        super.init(x: x, y: y, file: vertical == nil ? "road_m.png" : vertical! ? "road_v.png" : "road_h.png")
    }
}