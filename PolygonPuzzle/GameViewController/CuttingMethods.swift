//
//  CutteringMethods.swift
//  PolygonPuzzle
//
//  Created by Andrew Fenner on 8/7/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit


func getCutPoints(lines: [Line],cuttingLine: Line)-> [Node]? {
    var intersectionPoints: [Node] = []
    
    for l in lines {
        l.printme()
        if let intersectionPoint = l.intersectionPoint(line: cuttingLine){
            let newNode = Node(_location: intersectionPoint, _sister: SisterIndex)
            intersectionPoints.append(newNode)
        }
    }
    
    // Failure cases:
    if intersectionPoints.count > 2 || intersectionPoints.count == 1 || intersectionPoints.count == 0 {
        print("OH NO! These aren't valid intersection points!",intersectionPoints)
        return nil
    } else {
        return intersectionPoints
    }
    
}
