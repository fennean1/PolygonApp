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
    
    var potentialVertex: Node?
    
    let firstPointInActivePolygonsCoordinateSystem = subtractPoints(a: cuttingLine.firstPoint!, b: ActivePolygon.frame.origin)
    
    let secondPointInActivePolygonsCoordinateSystem = subtractPoints(a: cuttingLine.secondPoint!, b: ActivePolygon.frame.origin)
    
    // NODE: Need to know if first and last point are in active polygon.
    

    for l in lines {
        if let intersectionPoint = l.intersectionPoint(line: cuttingLine){
            let newNode = Node(_location: intersectionPoint, _sister: SisterIndex)
            intersectionPoints.append(newNode)
        }
    }
    
    //Assign vertext of cut. This may get reassigned to the same thing if this runs twice because the last point of the first like is equal to the first point of the last line. Maybe check here to make sure Vertex has already been set.
    
    // Don't run this if the vertex has already been set - we're only dealing with one for now.
    if let _ = VertexOfTheCut {
        // Do nothing right now.
    } else {
        if (ActivePolygon.polygonLayer.path?.contains(firstPointInActivePolygonsCoordinateSystem))! {
            potentialVertex = Node(_location: cuttingLine.firstPoint! , _sister: SisterIndex)
            //print("The first point is in the polygon!")
        }
        else if (ActivePolygon.polygonLayer.path?.contains(secondPointInActivePolygonsCoordinateSystem))! {
            potentialVertex = Node(_location: cuttingLine.secondPoint!, _sister: SisterIndex)
            //print("The second point is in the polygon!")
        }
    }
    print("intersectionPoints Count",intersectionPoints.count)
    if intersectionPoints.count > 2 {
        print("No, we're not dealing with more than 2 intersection points in a single cut. This case doesn't count the vertex.")
        return false
    } else if intersectionPoints.count == 2 {
        if abs(distance(a: (intersectionPoints.first?.location)!, b: (intersectionPoints.last?.location)!)) < 0.01 {
            print("These two points are the same")
            return false
        }
        else if let _ = StartOfCut {
            print("No, we're not dealing with two intersection points after the start of the cut has been set")
            return false
        } else {
            // Start of cut has not been set and there are two intersection points.
            print("Start of the cut has not been set and we found two intersection points")
            StartOfCut = intersectionPoints.first
            EndOfCut = intersectionPoints.last
            ValidCutHasBeenMade = true
            return true
        }
    } else if intersectionPoints.count == 1 {
        // If the start of the cut has been set and there's one intersection point then the endpoint is the intersection point.
        if let _ = StartOfCut {
            if let _ = VertexOfTheCut {
                print("Start and vertex have been set")
                EndOfCut = intersectionPoints.first!
                ValidCutHasBeenMade = true
                return true
            } else if let _ = potentialVertex {
                VertexOfTheCut = potentialVertex
                return true
            } else {
                return false
            }
        // If the start of the cut has not been set and there is one intersection point we set the start of the cut to the that intersection point and check to see if the vertex has been assigned.
        } else {
            // If the vertex has already been set, assign the
            if let _ = VertexOfTheCut {
                print("Vertex has been set but the start point has not - shouldn't this fail?")
                EndOfCut = intersectionPoints.first
                ValidCutHasBeenMade = true
                return true
            }
            else {
                print("One intersection point, start not set and vertex not set")
                StartOfCut = intersectionPoints.first!
                if let _ = potentialVertex {
                    VertexOfTheCut = potentialVertex
                }
                return true
            }
        }
    } else {
        print("failed intersection points at the final case")
        return false
    }
}
