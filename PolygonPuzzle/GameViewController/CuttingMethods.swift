//
//  CutteringMethods.swift
//  PolygonPuzzle
//
//  Created by Andrew Fenner on 8/7/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit


// Returns true if the intersection points are valid - I'm passing global variables to this. Really not necessary.
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
    
    
    // ... A new beginning...Attempting to deprecate the global "IntersectionNodes" which is currently combining both Start,End as well as vertices.
    if intersectionPoints.count == 2 {
        ValidCutHasBeenMade = true
        StartOfCut = intersectionPoints.first
        EndOfCut = intersectionPoints.last
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
        print("No, we're not dealing with more than 2 intersection points. This case doesn't count the vertex.")
    } else if intersectionPoints.count == 2 {
        if FirstStrokeHasBeenMade {
            print("No, we're not dealing with two intersection points on the second stroke. Intersection points set to empty")
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
    
    // Failure cases
    if IntersectionNodes.count > 3 || IntersectionNodes.count == 0 || IntersectionNodes.count == 1  {
        IntersectionNodes = []
        print("Not valid intersection nodes")
        return false
    }
    else if IntersectionNodes.count == 2 {
        if abs(distance(a: IntersectionNodes[0].location, b: IntersectionNodes[1].location)) < 0.01 {
            print("These two points are the same")
            return false
        } else {
            return true
        }
    } else {
        return true
    }
    
}
