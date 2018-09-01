//
//  CutteringMethods.swift
//  PolygonPuzzle
//
//  Created by Andrew Fenner on 8/7/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit


func getIntersectionPoints(lines: [Line],cuttingLine: Line) -> Bool {
   
    var intersectionPoints: [Node] = []
    
    let firstPointInActivePolygonsCoordinateSystem = subtractPoints(a: cuttingLine.firstPoint!, b: ActivePolygon.frame.origin)
    
    let secondPointInActivePolygonsCoordinateSystem = subtractPoints(a: cuttingLine.secondPoint!, b: ActivePolygon.frame.origin)
    
    for l in lines {
        if let intersectionPoint = l.intersectionPoint(line: cuttingLine){
            let newNode = Node(_location: intersectionPoint, _sister: SisterIndex)
            intersectionPoints.append(newNode)
        }
    }
    
    //Assign vertext of cut. This may get reassigned to the same thing if this runs twice.
    if (ActivePolygon.polygonLayer.path?.contains(firstPointInActivePolygonsCoordinateSystem))! {
        VertexOfTheCut = Node(_location: cuttingLine.firstPoint! , _sister: SisterIndex)
        print("The first point is in the polygon!")
    }
    else if (ActivePolygon.polygonLayer.path?.contains(secondPointInActivePolygonsCoordinateSystem))! {
        VertexOfTheCut = Node(_location: cuttingLine.secondPoint!, _sister: SisterIndex)
        print("The second point is in the polygon!")
    }
    
    if intersectionPoints.count > 2 {
        print("No, we're not dealing with more than 2 intersection points")
    } else if intersectionPoints.count == 2 {
        if FirstStrokeHasBeenMade {
            print("No, we're not dealing with two intersection points on the second stroke. Intersection points set to nil")
            intersectionPoints = []
        } else if !FirstStrokeHasBeenMade {
            // Bad Naming
            IntersectionNodes = intersectionPoints
        }
    } else if intersectionPoints.count == 1 {
        // If the first stroke hasn't been made
        if !FirstStrokeHasBeenMade {
            IntersectionNodes.append(intersectionPoints.first!)
            if let vertex = VertexOfTheCut {
                IntersectionNodes.append(vertex)
            }
        } else if FirstStrokeHasBeenMade {
            IntersectionNodes.append(intersectionPoints.first!)
        }
    }
    
    if IntersectionNodes.count > 3 {
        return false
    }
    else {
        return true
    }
    
}
