//
//  Shapes.swift
//  PolygonPuzzle
//
//  Created by Andrew Fenner on 7/21/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit
import Darwin


// For drawing regular polygons on gameview startup.
func getVerticesForType(numberOfSides: Int,radius: Double) -> [CGPoint] {
    
    let theta = 2*Double.pi/Double(numberOfSides)
    var points: [CGPoint] = []

        for i in 0...numberOfSides-1 {
            
            let m = Double(i)
            
            let _x = CGFloat(radius*cos(theta*m-Double.pi/2))
            let _y = CGFloat(radius*sin(theta*m-Double.pi/2))
            
            let point = CGPoint(x: _x, y: _y)
            
            points.append(point)
            
        }
    return points
}
